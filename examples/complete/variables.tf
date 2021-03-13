# provider variables

variable "region" {
  default     = "us-east-1"
  type        = string
  description = "AWS region"
}

variable "aws_assume_role_arn" {
  default     = ""
  type        = string
  description = "ARN of IAM role to assume"
}
