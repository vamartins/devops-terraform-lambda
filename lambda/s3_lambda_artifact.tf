module "awslab-s3-lambda-artifact" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "2.9.0"

  bucket                                = local.awslab_s3_lambda_artifact.bucket_name
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
      Name : local.awslab_s3_lambda_artifact.bucket_name
    }
  )
}