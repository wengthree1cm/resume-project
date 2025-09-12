variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}

variable "contact_from" {
  type        = string
  description = "SES verified sender email address (will receive a verification email)"
}

variable "contact_to" {
  type        = string
  description = "Destination email to receive contact form (verify too if SES sandbox)"
}

variable "site_bucket_name" {
  type        = string
  description = "S3 bucket name for static site (must be globally unique)"
}