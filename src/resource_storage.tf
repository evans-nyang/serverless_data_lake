# Import the existing S3 bucket into Terraform state
data "aws_s3_bucket" "sdl_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_ownership_controls" "sdl_bucket" {
  bucket = data.aws_s3_bucket.sdl_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "sdl_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.sdl_bucket]

  bucket = data.aws_s3_bucket.sdl_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning_sdl_bucket" {
  bucket = data.aws_s3_bucket.sdl_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}