terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "eu-west-1"
  profile = "cli"
}

module "route_hello" {
  source                    = "./modules/api-route-lambda"
  lambda_bucket             = aws_s3_bucket.lambda_bucket.id
  source_code_path          = "hello.js"
  zip_name                  = "hello.zip"
  lambda_function_name      = "hello"
  lambda_handler            = "hello.handler"
  api_gateway_id            = aws_apigatewayv2_api.main.id
  api_gateway_execution_arn = aws_apigatewayv2_api.main.execution_arn
  route_key                 = "GET /hello"
}

module "route_list" {
  source                    = "./modules/api-route-lambda"
  lambda_bucket             = aws_s3_bucket.lambda_bucket.id
  source_code_path          = "list.js"
  zip_name                  = "list.zip"
  lambda_function_name      = "list"
  lambda_handler            = "list.handler"
  api_gateway_id            = aws_apigatewayv2_api.main.id
  api_gateway_execution_arn = aws_apigatewayv2_api.main.execution_arn
  route_key                 = "GET /list"
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket        = "functions-456789"
  acl           = "private"
  force_destroy = true
}

resource "aws_apigatewayv2_api" "main" {
  name          = "serverless-terraform"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "main" {
  api_id      = aws_apigatewayv2_api.main.id
  name        = "main"
  auto_deploy = true
}
