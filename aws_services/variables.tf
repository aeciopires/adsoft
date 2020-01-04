variable "aws_zone" {
  description = "The zone to operate under, if not specified by a given resource."
  default     = "us-east-2"
}

variable "s3_bucket_name" {
  description = "S3 bucket name"
  default     = "adsoft_bucket"
}