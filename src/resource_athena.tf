resource "aws_athena_workgroup" "workgroup" {
  name = var.athena_workgroup

  configuration {
    result_configuration {
      output_location = "s3://${var.bucket_name}/athena-results/"
    }
  }
}

resource "aws_athena_data_catalog" "glue-data-catalog" {
  name        = var.athena_data_catalog
  description = "Glue based Data Catalog"
  type        = "GLUE"

  parameters = {
    "catalog-id" = "123456789012"
  }
}
