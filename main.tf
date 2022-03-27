# create a VPC

resource "aws_vpc" "first-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "first-vpc"
  }

}


# 2. Create Internet Gateway.

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.first-vpc.id


}

# 3. Create a route table.

resource "aws_route_table" "dev-route-table" {
  vpc_id = aws_vpc.first-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "dev-route-table"
  }

}

# 4. Create a subnet.

resource "aws_subnet" "subnet-1" {
  vpc_id            = aws_vpc.first-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "dev-subnet"
  }

}

#5. associate subnet with route table

resource "aws_route_table_association" "a" {

  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.dev-route-table.id

}

# 6. create security group to allow port 22,80, 443
resource "aws_security_group" "allow_web" {

  name        = "allow_web"
  description = "Allow web traffic"
  vpc_id      = aws_vpc.first-vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }



  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_web"
  }
}

# 7. create a network interface with an ip in the subnet that was created in step 4

resource "aws_network_interface" "web-server-nic" {

  subnet_id       = aws_subnet.subnet-1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]


}
# 8. Assign an elastic ip to the network interface

resource "aws_eip" "one" {

  vpc                       = true
  network_interface         = aws_network_interface.web-server-nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on = [
    aws_internet_gateway.igw
  ]



}


# 9. Create ubuntu server and install/enable apache2.

resource "aws_instance" "web-server-instance" {

  ami               = "ami-0851b76e8b1bce90b"
  instance_type     = "t2.micro"
  availability_zone = "ap-south-1a"

  key_name = "test"

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.web-server-nic.id

  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install apache2 -y
              sudo systemctl enable apache2
              sudo systemctl start apache2
              sudo bash -c 'echo "Hello i created this using Terraform" > /var/www/html/index.html' 
              EOF
  tags = {
    Name = "web-server-instance"
  }

}


# .terraform folder - when terraform init runs, it creates a .terraform folder in the current directory
# if we delete the folder, tf apply won't work. we need to run tf init again and download
# the plugin.

# terraform.tfstate - it represents all of the state for tf. it tracks everything on 
#  the tf file. if anything changes, it will update the tfstate file.



