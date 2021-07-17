variable "aws_region" {
  type    = string
  default = "us-east-1"
}
variable "instance_type" {
  type        = string
  description = "The EC2 instance type for the app"
  default     = "t2.micro"
}

variable "db_class" {
  type        = string
  description = "The db class for performance/memory"
  default     = "db.t2.micro"
}

variable "db_username" {
  type        = string
  description = "The username for the Postgres master user"
  sensitive   = true
}

variable "db_password" {
  type        = string
  description = "The password for the Postgres master user"
  sensitive   = true
}

variable "username" {
  type        = string
  description = "username for key aws_key_pair"
  default     = "Chauntel"
}