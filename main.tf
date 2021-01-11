variable "profile" {}
variable "region" {
  default = "us-east-1"
}

variable "aws_account_id" {}
variable "private_bucket_name" {}
variable "public_bucket_name" {}
variable "alb_log_bucket_name" {}

provider "aws" {
  region  = var.region
  profile = var.profile
}

# module "describe_regions_for_ec2" {
#   source     = "./iam_role"
#   name       = "describe-regions-for-ec2"
#   identifier = "ec2.amazonaws.com"
#   policy     = data.aws_iam_policy_document.allow_describe_regions.json
# }

module "create_s3_buckets" {
  source              = "./s3"
  aws_account_id      = var.aws_account_id
  private_bucket_name = var.private_bucket_name
  public_bucket_name  = var.public_bucket_name
  alb_log_bucket_name = var.alb_log_bucket_name
}
