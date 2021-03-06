Let's get some more practice! Now navigate to the directory path /root/terraform-projects/provider-a. Create a configuration file called code.tf.

Terraform
----------------

1. Resources - every object terraform manages that called resources 
2. A resource can be a EC2 instance, database, physical server on-prem
3. TF record the state of the infras.


HCL
---------

```
resource "local_file" "pet"{
	filename = "/root/pets.txt"
	content = "we love pets!"
	
}

```
Then run 
1. terraform init - check the configuration file, initialize the working directory containing the .TF file. what this commdand does 
is that we are making use of local provider based on the resource type declared in the resource block. It will then download the plugin to be 
able to work on the resources declared in the .TF file.

3. terraform plan - show the actions that will be carried by TF to create resource.
4. terraform apply - create the resource.


5. terraform show - see resource details


## Using Terraform Providers




here local_file is resource_type.
1. local - provider , provider can be anything like aws,gcp
2. file - type

pet - resource name -it can be anything.
filename, content - Arguments



Using the local_file resource type, write the resource block with the below requirements into the file:

Resource name = iac_code
File name = /opt/practice
Content = Setting up infrastructure as code



When ready, only run the terraform init command, we will run the terraform apply command later on.

```
resource "local_file" "iac_code" {
    filename="/opt/practice"
    content="Setting up infrastructure as code"

}

resource "local_file" "iac_code" {
	  filename = "/opt/practice"
	  content = "Setting up infrastructure as code"
}


resource "random_string" "iac_random" {
  length = 10
  min_upper = 5
}


```

Variables
String, MAP, LIST, Set, objects 
```
variable "distance" {
     type = number
     default = 5
  
}
variable "jedi" {
     type = map
     default = {
     filename = "/root/first-jedi"
     content = "phanius"
     }
  
}

variable "gender" {
     type = list(string)
     default = ["Male", "Female"]
}
variable "hard_drive" {
     type = map
     default = {
          slow = "HHD"
          fast = "SSD"
     }
}
variable "users" {
     type = set(string)
     default = ["tom", "jerry", "pluto", "daffy", "donald", "jerry", "chip", "dale"]

  
}


##main.tf

resource "local_file" "jedi" {
     filename = var.jedi["filename"]
     content = var.jedi["content"]
}
```

How can we use environment variables to pass input variables in terraform scripts?

Export variables using the prefix TF_VAR_ followed by the variable name and a value.

Which one of the following commands is a valid way to make use of a custom variable file with the terraform apply command?

Use the -var-file option with a variable file. The file can be named anything but should always end in either .tfvars or .tfvars.json

```

 resource "time_static" "time_update" {
}

resource "local_file" "time" {

    filename="/root/time.txt"
    content = "Time stamp of this file is ${time_static.time_update.id}"

  
}

```

Resource tls_private_key generates a secure private key and encodes it as PEM. It is a logical resource that lives only in the terraform state.
You can see the details of the resource, including the private key by running the terraform show command.



You can read the documentation for more details. https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key


Within this directory, create two local_file type resources in main.tf file.

Resource 1:
Resource Name: whale
File Name: /root/whale

Resource 2:
Resource Name: krill
File Name: /root/krill

Resource called whale should depend on krill but do not use reference expressions.



When ready, run terraform init, plan and apply.


```
resource "local_file" "whale" {
    filename = "/root/whale"
    depends_on = [local_file.krill]
    

}


resource "local_file" "krill" {
    filename = "/root/krill"

}
```
aws --endpoint http://aws:4566 iam create-user --user-name mary

{
    "User": {
        "Path": "/",
        "UserName": "mary",
        "UserId": "toz5gckew8wml1n8hh8a",
        "Arn": "arn:aws:iam::000000000000:user/mary",
        "CreateDate": "2022-03-12T13:36:07.514000+00:00"
    }
}

aws iam create-group --group-name Admins

create group
aws --endpoint http://aws:4566 iam create-group --group-name project-sapphire-developers
output
{
    "Group": {
        "Path": "/",
        "GroupName": "project-sapphire-developers",
        "GroupId": "4m2rbc3pwpklv7b4g1hm",
        "Arn": "arn:aws:iam::000000000000:group/project-sapphire-developers",
        "CreateDate": "2022-03-12T13:54:14.805000+00:00"
    }
}

Add user to group

add-user-to-group
--group-name <value>
--user-name <value>
[--cli-input-json <value>]
[--generate-cli-skeleton <value>]


aws --endpoint http://aws:4566 iam add-user-to-group --group-name project-sapphire-developers --user-name jack 

aws --endpoint http://aws:4566 iam add-user-to-group --group-name project-sapphire-developers --user-name jill

check attached policies
=========================
aws --endpoint http://aws:4566 iam list-attached-user-policies --user-name jack

iam attach-group-policy
=========================
aws --endpoint http://aws:4566 iam attach-group-policy --group-name project-sapphire-developers --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess

resource "aws_iam_user" "admin-user" 

resource = block name
aws=provider
iam_user = resource 
admin-user = resource name
<br/>

```
resource "aws_iam_user" "users"{
    name="mary"
}

```

terraform s3
---------------
```
resource "aws_s3_bucket" "finance"{
     bucket="finance"
     tags ={Description="Finance and Payroll"}
}

```

State Locking 
variable interpolation ${..}


First, create a simple configuration to create a local_file resource within the directory called RemoteState. The resource block should be created inside the main.tf file. Follow the below specifications for provisioning this resource:
Resource Name: state
filename: /root/<variable local-state>
content: "This configuration uses <variable local-state> state"



Use the variable called local-state in the variables.tf file which is already created for you and make use of variable interpolation syntax ${..}.
Once the configuration is ready, run a terraform init, plan and apply.



resource "local_file" "state" {

    filename = "/root/${var.local-state}"
    content = "This configuration uses ${var.local-state} state"

}

Access Key: foofoo
Secret Key: barbarbar

Now, let us configure the remote backend with s3. Add a terraform block in a new file called terraform.tf with the following arguments:

bucket: remote-state
key: terraform.tfstate
region: us-east-1


```
terraform {

    backend "s3" {
        key = "terraform.tfstate"
        bucket = "remote-state"
        region = "us-east-1"
    }
}

```

Terraform state commands
--------------------------

