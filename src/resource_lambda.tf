data "aws_iam_role" "sdl_lambda_role" {
  name = "SDL-LambdaRole"
}

resource "aws_lambda_function" "etl_lambda" {
  function_name    = var.function_name
  handler          = "transformation_generator.generate_etl_script"
  runtime          = "python3.8"
  role             = data.aws_iam_role.sdl_lambda_role.arn
  filename         = var.filepath
  source_code_hash = filebase64sha256("${var.filepath}")
  environment {
    variables = {
      bucket_name = var.bucket_name
    }
  }
}
