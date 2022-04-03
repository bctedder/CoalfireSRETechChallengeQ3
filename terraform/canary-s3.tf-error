#
# https://jarombek.com/blog/jul-26-2021-aws-synthetics-canary
#

#data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "clientapp-canaries" {
  bucket = "clientapp-canaries"

  tags = {
    Name = "clientapp-canaries"
    Application = "clientapp"
    Environment = "all"
  }
}

resource "aws_s3_bucket_policy" "clientapp-canaries-policy" {
  bucket = aws_s3_bucket.clientapp-canaries.id
  policy = jsonencode({
    Version = "2012-10-17"
    Id = "clientapp-canariesPolicy"
    Statement = [
      {
        Sid = "Permissions"
        Effect = "Allow"
        Principal = {
          AWS = data.aws_caller_identity.current.account_id
        }
        Action = ["s3:*"]
        Resource = ["${aws_s3_bucket.clientapp-canaries.arn}/*"]
      }
    ]
  })
}