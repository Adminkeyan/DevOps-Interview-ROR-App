
variable "aws_region" {
  default = "ap-south-1"
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "sampleuser"
}

variable "db_password" {
  description = "Database password"
  type        = string
  default     = "SampleP@ssw0rd!"
}
