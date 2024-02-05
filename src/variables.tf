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

# AWS Kinesis 
variable "firehose_stream_name" {
  description = "Name of kinesis firehose data stream"
  type        = string
}

# AWS Glue 
variable "database_name" {
  description = "Name of glue crawler database"
  type        = string
}

variable "table_name" {
  description = "Name of table in glue crawler database"
  type        = string
}

variable "crawler_name" {
  description = "Name of glue crawler"
  type        = string
}

variable "glue_job_name" {
  description = "Name of the glue job"
  type        = string
}

variable "trigger_name" {
  description = "Name of etl trigger"
  type        = string
}

# AWS Lambda 
variable "function_name" {
  description = "Name of lambda handler"
  type        = string
}

variable "execution_role" {
  description = "The name of lambda execcution role"
  type        = string
}

variable "filepath" {
  description = "The path of the lambda executable script"
  type        = string
}

# AWS Athena 
variable "athena_workgroup" {
  description = "Athena workgroup name"
  type        = string
}

variable "athena_data_catalog" {
  description = "Athena Glue based data catalog name"
  type        = string
}

variable "athena_named_query" {
  description = "Athena named query name"
  type        = string
}

variable "query_location" {
  description = "Athena named query location"
  type        = string
}

# AWS Quicksight 
variable "account_name" {
  description = "Aws Quicksight account name"
  type        = string
}

variable "authentication_method" {
  description = "Quicksight authentication method"
  type        = string
}

variable "edition" {
  description = "User preferred Quicksight edition"
  type        = string
}

variable "notification_email" {
  description = "Quicksight registered email for notification"
  type        = string
}
