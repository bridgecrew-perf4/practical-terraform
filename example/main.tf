provider "aws" {
  region  = "us-east-1"
  profile = "ikhrnet"
}

resource "aws_instance" "example" {
  ami           = "ami-0be2609ba883822ec"
  instance_type = "t3.nano"
}
