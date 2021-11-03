locals {

  prefix = "${var.project_code}-${var.application_name}"
  # Common tags to be assigned to all resources
  common_tags = {
    service_name = "ci/cd pipeline"
    provisioner  = "terraform"
    owner        = "Vagner Almeida Martins"
  }

  awslab_s3_lambda_artifact = {
    bucket_name = "${local.prefix}-${var.environment}-lambda-artifact"
  }

  awslab_s3_lambda_trigger = {
    bucket_name = "${local.prefix}-${var.environment}-lambda-trigger"
  }

  awslab_lambda = {
    name        = "${local.prefix}-${var.environment}-lambda"
    handler     = "index.handler"
    runtime     = "nodejs14.x"
    memory_size = 128
    timeout     = 900
  }
}

variable "region" {
  type        = string
  description = "Region where resources are going to be deployed"
  default     = "us-east-2"
}

variable "environment" {
  type = string
}

variable "project_code" {
  type = string
}

variable "application_name" {
  type = string
}