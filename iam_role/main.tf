variable "name" {}
variable "policy" {}
variable "identifier" {}

resource "aws_iam_role" "default" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = [var.identifier]
    }
  }
}

# Error: Reference to undeclared resource
# 
#   on main.tf line 5, in module "describe_regions_for_ec2":
#    5:   policy     = data.aws_iam_policy_document.allow_describe_regions.json
# 
# A data resource "aws_iam_policy_document" "allow_describe_regions" has not
# been declared in the root module.

# data "aws_iam_policy_document" "allow_describe_regions" {
#   ...
# }

resource "aws_iam_policy" "default" {
  name   = var.name
  policy = var.policy
}

resource "aws_iam_role_policy_attachment" "default" {
  role       = aws_iam_role.default.name
  policy_arn = aws_iam_policy.default.arn
}

output "iam_role_arn" {
  value = aws_iam_role.default.arn
}

output "iam_role_name" {
  value = aws_iam_role.default.name
}

# output "iam_role_assume_role_policy" {
#   value = aws_iam_role.default.assume_role_policy
# }
