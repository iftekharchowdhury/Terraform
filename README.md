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