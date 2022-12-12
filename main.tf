locals {

}

data "http" "book" {
  url = "https://openlibrary.org/works/OL45883W.json"
}

module "route_hello" {
  source                    = "./modules/api-route-lambda"
  source_code_path          = "hello.js"
  zip_name                  = "hello.zip"
  lambda_function_name      = "hello"
  lambda_handler            = "hello.handler"
  route_key                 = "GET /hello"
  lambda_bucket             = aws_s3_bucket.lambda_bucket.id
  api_gateway_id            = aws_apigatewayv2_api.main.id
  api_gateway_execution_arn = aws_apigatewayv2_api.main.execution_arn
  db_host                   = var.db_host
  db_user                   = var.db_user
  db_pass                   = var.db_pass
}

module "route_list" {
  source                    = "./modules/api-route-lambda"
  source_code_path          = "list.js"
  zip_name                  = "list.zip"
  lambda_function_name      = "list"
  lambda_handler            = "list.handler"
  route_key                 = "GET /list"
  lambda_bucket             = aws_s3_bucket.lambda_bucket.id
  api_gateway_id            = aws_apigatewayv2_api.main.id
  api_gateway_execution_arn = aws_apigatewayv2_api.main.execution_arn
  db_host                   = var.db_host
  db_user                   = var.db_user
  db_pass                   = var.db_pass
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket        = "functions-456789"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "lambda_bucket_acl" {
  bucket = aws_s3_bucket.lambda_bucket.id
  acl    = "private"
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

resource "aws_ssm_parameter" "book_OL45883W" {
  name  = "/book/OL45883W"
  type  = "String"
  value = data.http.book.body
}

resource "local_file" "api" {
  content  = "{ \"api\": \"${aws_apigatewayv2_api.main.api_endpoint}\" }"
  filename = "config.json"
}

# RSA key of size 4096 bits
resource "tls_private_key" "rsa_4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "ssh_private_key" {
  content  = tls_private_key.rsa_4096.private_key_pem
  filename = "ssh_private_key.pem"
}

resource "local_file" "ssh_public_key" {
  content  = tls_private_key.rsa_4096.public_key_pem
  filename = "ssh_public_key.pem"
}

resource "aws_ssm_parameter" "demo_import" {
  name  = "/demo/import"
  type  = "String"
  value = "top secret"
}
