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