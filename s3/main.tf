variable "aws_account_id" {}
variable "private_bucket_name" {}
variable "public_bucket_name" {}
variable "alb_log_bucket_name" {}

# "private-pragmatic-terraform-ikhrnet"
# "public-progmatic-terraform-ikhrnet"
# "alb-log-pragmatic-terraform-ikhrnet"

resource "aws_s3_bucket" "private" {
  bucket        = var.private_bucket_name
  force_destroy = true

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "private" {
  bucket                  = aws_s3_bucket.private.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "public" {
  bucket        = var.public_bucket_name
  force_destroy = true
  acl           = "public-read"

  cors_rule {
    allowed_origins = ["https://example.com"]
    allowed_methods = ["GET"]
    allowed_headers = ["*"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket" "alb_log" {
  bucket        = var.alb_log_bucket_name
  force_destroy = true

  lifecycle_rule {
    enabled = true

    expiration {
      days = "180"
    }
  }
}

data "aws_iam_policy_document" "alb_log" {
  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.alb_log.id}/*"]

    principals {
      type        = "AWS"
      identifiers = [var.aws_account_id]
    }
  }
}
