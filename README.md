## Prerequisites to run example Infrastructure 
* To have or create a VPC with at least 3 subnets (on different AZ's) where the resources are going to be created.
* [Install](https://learn.hashicorp.com/tutorials/terraform/install-cli) terraform in the machines that will execute.
* [Install](https://terragrunt.gruntwork.io/docs/getting-started/install/) terragrunt in the machines that will execute.
* [Install](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) AWS CLI in the machines that will execute.
* To have or create a IAM user with admin permissions to create and manage the AWS resources.
## How to create example Infrastructure
### AWS example variables and parameters
Since the development of the TF templates and all of the infrastructure was done on a example AWS account, information like vpc id, subnets, ip’s... is specific for our
environment.
This list of parameters are the ones that needs to be modified in the variables file on Terraform in order for example team to spin up the AWS components on their environment:
* VPC ID
* Subnet ID
* AMI ID
* Key Pairs
* Region
* Availability Zone
* Terraform state bucket path *(changed in terragrunt file)*

Before we start, please make sure you don't see any .terraform file in the terraform modules, if so, please proceed to delete them. 
1. With your IAM programmatically credentials, login to  AWS CLI running:
```shell
aws configure
 ```
2. Run the following terragrunt command to initialize Terraform modules 
```shell
 terragrunt init 
 ```
3. Run the following terragrunt command to plan all the infrastructure that terraform will deploy on AWS:
```shell
 terragrunt plan 
 ```
4. Run the following terragrunt command to deploy all your example modules to AWS.
```shell
 terragrunt run-all apply --auto-approve 
 ```
5. Test all your AWS resources have been created by Terraform.

# Creating Ansible Tower

- To deploy Ansible Tower, we need to deploy IaC module *ansible-tower* using Terraform or Terragrunt.

- After creating Ansible Tower IaC, we can login in the Ansible Tower Console, to activate the software (you will need your Red Hat account, with Ansible Tower license).

- Login credentials are defined on user_data.tpl script within the Ansible Tower module and they can be changed as it requerid.

- Then you would need to activate the Ansible Tower Software.


To make Ansible Tower work, we need to create basically 5 things: a project, an inventory, a hosts file, a template and the playbook that you want to run.

#### Project

In the project section, you configure the variables and paths from this project.


#### Inventory 

In the inventory, you need to put the name and the IP address of the host you want to configure 


#### Template

To configure a new Template, you need have a YAML in the path directory you define on the **Project** section.
+ **Name**: Name you'll assign to the template.
+ **Description**: A brief description of what template is doing.
+ **Inventory**: Inventory you created in the ##Inventory## section
+ **Project**: Projecto you created in the ##Project## section
+ **Playbook**: Playbook you're going to run. *(Go to Playbooks section for more information)*
+ **Credentials**: Credentials you'll use to execute the template.


#### Hosts

The hosts file it's just a name definition to use on the inventory. If you want to add a host, go to add botton and fill as follow:
+ **Name**: DNS Name or IP Address.
+ **Inventory**: Inventory which the host will be part
+ **Description**: A brief description of the host.

#### Yaml Section
Here you can configure a YAML file that define parameters such as: 
---
+ hostname
+ domain
+ domainuser
+ userpass


## Playbooks

For the playbook section, we need to put all the files you want to use on the project, in the path defined on the project step. Scripts and Playbook are included on *playbook.zip* file.


To execute the playbook, you need to click on the rocket icon and Ansible will execute the template you defined.








