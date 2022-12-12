variable "lambda_bucket" {
  description = "S3 Bucket to oupload Lambda Zip files"
  type        = string
  default     = "lambdas"
}

variable "zip_name" {
  description = "Zip file name"
  type        = string
  default     = "lambda.zip"
}

variable "source_code_path" {
  type        = string
  description = "Path to source code in functions folder"
  default     = ""
}

variable "lambda_function_name" {
  type        = string
  description = "Lambda function name"
  default     = "hello"
}

variable "lambda_handler" {
  type        = string
  description = "Lambda handler"
  default     = "hello.js"
}

variable "api_gateway_id" {
  type        = string
  description = "ID of Api Gateway"
  default     = ""
}

variable "api_gateway_execution_arn" {
  type        = string
  description = "ID of Api Gateway execution arn"
  default     = ""
}

variable "route_key" {
  type        = string
  description = "Api Gateway Route"
  default     = "GET /hello"
}

variable "db_user" {
  description = "DB user"
  type        = string
  default     = "admin"
}

variable "db_pass" {
  description = "DB password"
  type        = string
  sensitive   = true
}

variable "db_host" {
  description = "DB host"
  type        = string
  default     = "localhost"
}
