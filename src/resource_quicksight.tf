resource "aws_quicksight_account_subscription" "subscription" {
  account_name          = var.account_name
  authentication_method = var.authentication_method
  edition               = var.edition
  notification_email    = var.notification_email
}
