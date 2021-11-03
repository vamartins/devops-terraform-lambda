{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:Get*",
        "s3:Delete*",
        "s3:List*",
        "s3:Put*"
      ],
      "Effect": "Allow",
      "Resource": "${s3_arn}/*"
    },
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:logs:*:*:*"
      }
  ]
}