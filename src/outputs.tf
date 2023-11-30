output "bucket_name" {
  value = "${local.bucket_name_prefix}-${var.aws_account_id}"
}
