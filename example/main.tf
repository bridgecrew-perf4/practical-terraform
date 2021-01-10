provider "aws" {
  region  = "us-east-1"
  profile = "ikhrnet"
}

resource "aws_instance" "example" {
  ami           = "ami-0be2609ba883822ec"
  instance_type = "t3.nano"

  tags = {
    Name = "example"
  }

  user_data = <<EOF
    #/bin/bash
    yum install -y httpd
    systemctl start httpd.service
EOF
}
