module "awslab-s3-lambda-trigger" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "2.9.0"

  bucket                                = local.awslab_s3_lambda_trigger.bucket_name
  acl                                   = "private"
  attach_deny_insecure_transport_policy = true
  block_public_acls                     = true
  block_public_policy                   = true
  ignore_public_acls                    = true
  restrict_public_buckets               = true
  versioning = {
    enabled = false
  }
  tags = merge(local.common_tags,
    {
      name : local.awslab_s3_lambda_trigger.bucket_name
    }
  )
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.awslab_lambda_s3_resize.arn
  principal     = "s3.amazonaws.com"
  source_arn    = module.awslab-s3-lambda-trigger.s3_bucket_arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = local.awslab_s3_lambda_trigger.bucket_name

  lambda_function {
    lambda_function_arn = aws_lambda_function.awslab_lambda_s3_resize.arn
    events = [
    "s3:ObjectCreated:*"]
  }

  depends_on = [
  aws_lambda_permission.allow_bucket]
}