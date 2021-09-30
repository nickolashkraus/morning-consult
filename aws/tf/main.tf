# -----------------------------------------------------------------------------
# Stream processing with Amazon Kinesis, AWS Lambda, and Amazon S3.
# -----------------------------------------------------------------------------

resource "aws_kinesis_stream" "kinesis_stream" {
  name             = "morning-consult-kinesis-stream"
  shard_count      = 1
  retention_period = 48

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]

}

resource "aws_iam_role" "lambda_iam_role" {
  name               = "morning-consult-lambda-iam-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_iam_assume_role_policy_document.json
}

resource "aws_iam_role_policy" "lambda_iam_role_policy" {
  policy = data.aws_iam_policy_document.lambda_iam_policy_document.json
  role   = aws_iam_role.lambda_iam_role.id
}

data "aws_iam_policy_document" "lambda_iam_assume_role_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_iam_policy_document" {
  statement {
    actions = [
      "kinesis:DescribeStream",
      "kinesis:DescribeStreamSummary",
      "kinesis:GetRecords",
      "kinesis:GetShardIterator",
      "kinesis:ListShards",
      "kinesis:ListStreams",
      "kinesis:SubscribeToShard",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = ["*"]
  }
}

resource "aws_lambda_function" "lambda" {
  filename      = "../src/function.zip"
  function_name = "morning-consult-lambda"
  role          = aws_iam_role.lambda_iam_role.arn
  handler       = "main"

  source_code_hash = filebase64sha256("../src/function.zip")

  runtime = "go1.x"
}

resource "aws_lambda_event_source_mapping" "example" {
  event_source_arn  = aws_kinesis_stream.kinesis_stream.arn
  function_name     = aws_lambda_function.lambda.arn
  starting_position = "LATEST"
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "morning-consult-s3-bucket"
  acl    = "public-read-write"
}
