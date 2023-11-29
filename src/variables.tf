variable "region" {
  type    = string
  default = "us-east-1"  # Update with your desired AWS region
}

variable "bucket_name" {
  type    = string
  default = "sdl-immersion-day-${var.aws_account_id}"  
}

variable "environment" {
  type    = string
  default = "dev"  # Update with your desired environment name
}

variable "aws_account_id" {
  type    = string
  default = "123456789012"  # Update with your AWS account ID
}
