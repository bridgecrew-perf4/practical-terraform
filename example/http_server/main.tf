variable "instance_type" {}
variable "profile" {}

variable "region" {
  default = "us-east-1"
}

locals {
  cidr_blocks = ["0.0.0.0/0"]
}


provider "aws" {
  region  = var.region
  profile = var.profile
}

data "aws_ami" "recent_amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.????????-x86_64-gp2"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}


resource "aws_instance" "default" {
  ami                    = data.aws_ami.recent_amazon_linux_2.image_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.default.id]

  tags = {
    Name = "example"
  }

  user_data = <<EOF
    #!/bin/bash
    yum install -y httpd
    systemctl start httpd.service
EOF
}

resource "aws_security_group" "default" {
  name = "ec2"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = local.cidr_blocks
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = local.cidr_blocks
  }
}


output "ami_id" {
  value = aws_instance.default.ami
}

output "instance_id" {
  value = aws_instance.default.id
}

output "public_dns" {
  value = "http://${aws_instance.default.public_dns}"
}
