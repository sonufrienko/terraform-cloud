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
