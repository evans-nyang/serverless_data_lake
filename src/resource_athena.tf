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
    "catalog-id" = var.aws_account_id
  }
}

resource "aws_athena_named_query" "sdl_named_query" {
  name        = var.athena_named_query
  workgroup   = aws_athena_workgroup.workgroup.id
  database    = var.database_name
  description = "sdl athena named query"
  query       = file(var.query_location)
}
