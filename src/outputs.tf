output "bucket_name" {
  description = "The s3 bucket name"
  value       = "${local.bucket_name_prefix}-${var.aws_account_id}"
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = data.aws_s3_bucket.sdl_bucket.arn
}

output "firehose_stream_name" {
  description = "The name of the Kinesis Firehose delivery stream"
  value       = aws_kinesis_firehose_delivery_stream.sdl_firehose_stream.name
}

output "glue_database_name" {
  description = "The name of the Glue Catalog Database"
  value       = aws_glue_catalog_database.sdl_crawler_db.name
}

output "glue_crawler_name" {
  description = "The name of the Glue Crawler"
  value       = aws_glue_crawler.sdl_glue_crawler.name
}