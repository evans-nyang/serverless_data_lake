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