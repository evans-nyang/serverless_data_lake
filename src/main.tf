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

# Import the existing S3 bucket into Terraform state
data "aws_s3_bucket" "my_serverless" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_ownership_controls" "my_serverless" {
  bucket = data.aws_s3_bucket.my_serverless.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "my_serverless" {
  depends_on = [aws_s3_bucket_ownership_controls.my_serverless]

  bucket = data.aws_s3_bucket.my_serverless.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning_my_serverless" {
  bucket = data.aws_s3_bucket.my_serverless.id
  versioning_configuration {
    status = "Enabled"
  }
}
data "aws_iam_role" "my_firehose_role" {
  name = "SDL-FirehoseRole"
}

resource "aws_kinesis_firehose_delivery_stream" "my_firehose_stream" {
  name        = "sdl-firehose-stream"
  destination = "s3"

  s3_configuration {
    role_arn            = data.aws_iam_role.my_firehose_role.arn
    bucket_arn          = data.aws_s3_bucket.my_serverless.arn
    buffer_size         = 1
    buffer_interval     = 60
    compression_format  = "GZIP"
    error_output_prefix = "error/"
    prefix              = "raw/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/hour=!{timestamp:HH}/"
  }
}
