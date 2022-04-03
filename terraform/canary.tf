
#
# https://jarombek.com/blog/jul-26-2021-aws-synthetics-canary
#

data "aws_s3_bucket" "clientapp-canaries" {
  bucket = "clientapp-canaries"
  depends_on = [
    aws_s3_bucket.clientapp-canaries
  ]
}

data "aws_iam_role" "canary-role" {
  name = "canary-role"
  depends_on = [
    aws_iam_role.canary-role
  ]
}

resource "aws_synthetics_canary" "clientapp-up" {
  count = 1
  name = "clientapp-up"
  #name = "Web_Application_Alive"
  artifact_s3_location = "s3://${data.aws_s3_bucket.clientapp-canaries.id}/"
  execution_role_arn = data.aws_iam_role.canary-role.arn
  runtime_version = "syn-nodejs-puppeteer-3.5"
  handler = "up.handler"
  zip_file = "${path.module}/clientappUp.zip"
  start_canary = true

  success_retention_period = 2
  failure_retention_period = 14

  schedule {
    expression = "rate(5 minutes)"
    duration_in_seconds = 30
  }

  run_config {
    timeout_in_seconds = 300
    memory_in_mb = 960
    active_tracing = false
  }

  vpc_config {
      subnet_ids = [aws_subnet.wp-private-subnets[count.index].id]
      security_group_ids = [aws_security_group.webaccess-sg.id]
  }

  tags = {
    Name = "clientapp-up-canary"
    Application = "clientapp"
  }
}
