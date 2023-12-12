locals {
  bucket_name_prefix = "sdl-immersion-day"
}

variable "region" {
  description = "AWS region for deployment of resources"
  type        = string
}

variable "bucket_name" {
  description = "The name of S3 bucket"
  type        = string
}

variable "environment" {
  description = "Environment setup either dev or prod"
  type        = string
}

variable "aws_account_id" {
  description = "AWS account number"
  type        = string
}

variable "firehose_stream_name" {
  description = "Name of kinesis firehose data stream"
  type        = string
}

variable "database_name" {
  description = "Name of glue crawler database"
  type        = string
}

variable "crawler_name" {
  description = "Name of glue crawler"
  type        = string
}
