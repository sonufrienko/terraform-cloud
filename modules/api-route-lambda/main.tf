terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2"
    }
  }

  required_version = ">= 1.2.0"
}

locals {
  lambda_runtime = "nodejs14.x"
  lambda_handler = "list.handler"
}


data "archive_file" "zip" {
  type        = "zip"
  source_file = "${path.module}/../../functions/${var.source_code_path}"
  output_path = "${path.module}/../../functions/${var.zip_name}"
}

resource "aws_s3_object" "object" {
  bucket = var.lambda_bucket

  key    = var.zip_name
  source = data.archive_file.zip.output_path

  etag = filemd5(data.archive_file.zip.output_path)
}

resource "aws_iam_role" "lambda_exec" {
  name = "${var.lambda_function_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_lambda_function" "lambda" {
  function_name = var.lambda_function_name
  runtime       = local.lambda_runtime
  handler       = var.lambda_handler

  s3_bucket = var.lambda_bucket
  s3_key    = var.zip_name

  source_code_hash = data.archive_file.zip.output_base64sha256
  role             = aws_iam_role.lambda_exec.arn

  environment {
    variables = {
      DB_URL = "bar"
    }
  }
}

resource "aws_cloudwatch_log_group" "function_hello" {
  name              = "/aws/lambda/${aws_lambda_function.lambda.function_name}"
  retention_in_days = 30
}




resource "aws_apigatewayv2_integration" "lambda" {
  api_id = var.api_gateway_id

  integration_uri    = aws_lambda_function.lambda.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "route" {
  api_id    = var.api_gateway_id
  route_key = var.route_key

  target = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

resource "aws_lambda_permission" "api_gw" {
  statement_id = "AllowExecutionFromAPIGateway"
  action       = "lambda:InvokeFunction"
  principal    = "apigateway.amazonaws.com"

  function_name = aws_lambda_function.lambda.function_name
  source_arn    = "${var.api_gateway_execution_arn}/*/*"
}
