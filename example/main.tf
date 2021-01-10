variable "profile" {
  default = "ikhrnet"
}

locals {
  example_instance_type = "t3.nano"
}

provider "aws" {
  region  = "us-east-1"
  profile = var.profile
}

resource "aws_instance" "example" {
  ami           = "ami-0be2609ba883822ec"
  instance_type = local.example_instance_type

  tags = {
    Name = "example"
  }

  user_data = <<EOF
    #/bin/bash
    yum install -y httpd
    systemctl start httpd.service
EOF
}
