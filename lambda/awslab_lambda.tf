data "archive_file" "awslab_lambda_artifact" {
  type = "zip"

  source_dir  = "${path.module}/src"
  output_path = "${path.module}/awslab-s3-resize.zip"
}

resource "aws_s3_bucket_object" "awslab_s3_lambda" {
  bucket = module.awslab-s3-lambda-artifact.s3_bucket_id
  key    = "awslab-s3-resize.zip"
  source = data.archive_file.awslab_lambda_artifact.output_path
  etag   = filemd5(data.archive_file.awslab_lambda_artifact.output_path)
}


resource "aws_lambda_function" "awslab_lambda_s3_resize" {
  function_name    = local.awslab_lambda.name
  runtime          = local.awslab_lambda.runtime
  handler          = local.awslab_lambda.handler
  memory_size      = local.awslab_lambda.memory_size
  timeout          = local.awslab_lambda.timeout
  s3_bucket        = module.awslab-s3-lambda-artifact.s3_bucket_id
  s3_key           = aws_s3_bucket_object.awslab_s3_lambda.key
  source_code_hash = data.archive_file.awslab_lambda_artifact.output_base64sha256
  role             = aws_iam_role.lambda_exec.arn
  tags = merge(local.common_tags,
    {
      name : local.awslab_lambda.name
    }
  )
}

resource "aws_cloudwatch_log_group" "awslab_lambda_s3_resize" {
  name              = "/aws/lambda/${aws_lambda_function.awslab_lambda_s3_resize.function_name}"
  retention_in_days = 1
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  role   = aws_iam_role.lambda_exec.name
  policy = data.template_file.awslab-lambda-policy.rendered
}

data "template_file" "awslab-lambda-policy" {
  template = file("${path.module}/policies/awslab_lamdba_policy.tpl")
  vars = {
    s3_arn = module.awslab-s3-lambda-trigger.s3_bucket_arn
  }
}

resource "aws_iam_role_policy_attachment" "awslab_lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}