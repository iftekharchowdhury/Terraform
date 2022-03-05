Let's get some more practice! Now navigate to the directory path /root/terraform-projects/provider-a. Create a configuration file called code.tf.

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
