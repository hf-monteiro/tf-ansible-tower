provider "aws" {
  region = var.region
  profile = "default"
}

################################################################################
# Supporting Resources
################################################################################

## EC2 AMI ##
data "aws_ami" "ansible_tower_image" {
  most_recent = true
  owners      = ["self"] # amazon, aws-marketplace or self

  filter {
    name   = "image-id"
    values = [var.image_id]
  }
}

## SG ##
module "security_group" {
  source  = "../modules/sg_security_group"

  name        = var.name
  description = "Security group for usage with EC2 instance"
  vpc_id      = var.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH access"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "vpc all traffic"
      cidr_blocks = "172.31.0.0/16"
    }
  ]

  # egress
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "all"
      description = "All traffic out"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = local.tags
}

################################################################################
# EC2 Module
################################################################################


module "ec2" {
  source = "../modules/ec2_instance"

  name                        = var.name
  ami                         = data.aws_ami.ansible_tower_image.id
  instance_type               = var.instance_type
  availability_zone           = var.availability_zone
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [module.security_group.security_group_id]
  associate_public_ip_address = true
  hibernation                 = true
  key_name                    = var.key_name
  user_data                   = file("user_data.tpl")

  enable_volume_tags = true
  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = 50
    },
  ]
}

## Interface ##

resource "aws_network_interface" "this" {
  subnet_id = var.subnet_id
}

module "ec2_network_interface" {
  source = "../modules/ec2_instance"

  name = "${var.name}-network-interface"

  ami           = data.aws_ami.ansible_tower_image.id
  instance_type = var.instance_type

  network_interface = [
    {
      device_index          = 0
      network_interface_id  = aws_network_interface.this.id
      delete_on_termination = false
    }
  ]
}

