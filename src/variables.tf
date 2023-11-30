variable "region" {
  type    = string
  default = "eu-west-1" # Update with your desired AWS region
}

variable "bucket_name" {
  type    = string
  default = "sdl-immersion-day-123456789012" # Update with your desired bucket name
}

variable "environment" {
  type    = string
  default = "dev" # Update with your desired environment name
}

variable "aws_account_id" {
  type    = string
  default = "123456789012" # Update with your AWS account ID
}

locals {
  bucket_name_prefix = "sdl-immersion-day"
}
