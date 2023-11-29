terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">=1.2.0"
}

provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "my_serverless" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

resource "aws_s3_bucket_ownership_controls" "my_serverless" {
  bucket = aws_s3_bucket.my_serverless.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "my_serverless" {
  depends_on = [aws_s3_bucket_ownership_controls.my_serverless]

  bucket = aws_s3_bucket.my_serverless.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning_my_serverless" {
  bucket = aws_s3_bucket.my_serverless.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_iam_role" "my_firehose_role" {
  name = "SDL-FirehoseRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "",
        Effect    = "Allow",
        Principal = {
          Service = "firehose.amazonaws.com"
        },
        Action = "sts:AssumeRole",
        Condition = {
          StringEquals = {
            "sts:ExternalId" = var.aws_account_id
          }
        }
      }
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  ]
}

resource "aws_kinesis_firehose_delivery_stream" "my_firehose_stream" {
  name        = "sdl-firehose-stream"
  destination = "s3"

  s3_configuration {
    role_arn                = aws_iam_role.my_firehose_role.arn
    bucket_arn              = aws_s3_bucket.my_serverless.arn
    buffer_size             = 1
    buffer_interval         = 60
    compression_format      = "GZIP"
    error_output_prefix     = "error/"
    prefix                  = "raw/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/hour=!{timestamp:HH}/"
  }
}
