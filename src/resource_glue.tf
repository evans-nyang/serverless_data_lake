data "aws_iam_role" "sdl_glue_role" {
  name = "SDL-GlueRole"
}

resource "aws_glue_catalog_database" "sdl_crawler_db" {
  name = var.database_name
}

resource "aws_glue_crawler" "sdl_glue_crawler" {
  database_name = aws_glue_catalog_database.sdl_crawler_db.name
  name          = var.crawler_name
  role          = data.aws_iam_role.sdl_glue_role.arn

  s3_target {
    path = "${data.aws_s3_bucket.sdl_bucket.arn}/raw/*"
  }
}

resource "aws_glue_job" "transform_json_to_parquet" {
  name     = "transform-json-to-parquet"
  role_arn = data.aws_iam_role.sdl_glue_role.arn
  command {
    name            = "glueetl"
    script_location = "s3://sdl-immersion-day-${var.aws_account_id}/scripts/transform-json-to-parquet.py"
  }

  glue_version      = "3.0"
  worker_type       = "G.1X"
  number_of_workers = 10 # You can adjust this based on your needs

  execution_property {
    max_concurrent_runs = 1
  }

  default_arguments = {
    "--job-language" = "python"
  }
}
