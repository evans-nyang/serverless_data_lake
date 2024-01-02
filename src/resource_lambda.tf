resource "aws_lambda_function" "etl_lambda" {
  function_name    = var.function_name
  handler          = "index.handler"
  runtime          = "python3.8"
  role             = aws_iam_role.lambda_role.arn
  filename         = var.filepath
  source_code_hash = filebase64sha256("${var.filepath}")
  environment {
    variables = {
      bucket_name = var.bucket_name
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name = var.execution_role
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "lambda_policy_attachment" {
  name       = "lambda_policy_attachment"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
