locals {
  bucket_name_prefix = "sdl-immersion-day"
}

variable "region" {
  description = "AWS region for deployment of resources"
  type        = string
  default     = "eu-west-1" # Update with your desired AWS region
}

variable "bucket_name" {
  description = "The name of S3 bucket"
  type        = string
  default     = "sdl-immersion-day-123456789012" # Update with your desired bucket name
}

variable "environment" {
  description = "Environment setup either dev or prod"
  type        = string
  default     = "dev" # Update with your desired environment name
}

variable "aws_account_id" {
  description = "AWS account number"
  type        = string
  default     = "123456789012" # Update with your AWS account ID
}

variable "firehose_stream_name" {
  description = "Name of kinesis firehose data stream"
  type        = string
  default     = "sdl-firehose-stream"
}

variable "database_name" {
  description = "Name of glue crawler database"
  type        = string
  default     = "sdl-database"
}

variable "crawler_name" {
  description = "Name of glue crawler"
  type        = string
  default     = "sdl-crawler"
}