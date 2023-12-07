data "aws_iam_role" "sdl_firehose_role" {
  name = "SDL-FirehoseRole"
}

resource "aws_kinesis_firehose_delivery_stream" "sdl_firehose_stream" {
  name        = var.firehose_stream_name
  destination = "s3"

  s3_configuration {
    role_arn            = data.aws_iam_role.sdl_firehose_role.arn
    bucket_arn          = data.aws_s3_bucket.sdl_bucket.arn
    buffer_size         = 1
    buffer_interval     = 60
    compression_format  = "GZIP"
    error_output_prefix = "error/"
    prefix              = "raw/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/hour=!{timestamp:HH}/"
  }
}