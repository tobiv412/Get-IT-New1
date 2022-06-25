# ARCHIVE PYTHON SCRIPT FOR LAMBDA
data "archive_file" "lambda_file" {
  type        = "zip"
  source_file = "${path.module}/files/detect.py"
  output_path = "${path.module}/lambda.zip"
}

# CREATE LAMBDA FUNCTION
resource "aws_lambda_function" "image_recog_analysis" {
  filename         = data.archive_file.lambda_file.output_path
  function_name    = "detect"
  role             = aws_iam_role.lambda_role.arn
  handler          = "detect.lambda_handler"
  source_code_hash = filebase64sha256(data.archive_file.lambda_file.output_path)

  runtime = "python3.8"

  timeout = "60"
  # environment variables
  environment {
    variables = {
      "IMAGE_BUCKET" = aws_s3_bucket.image_reg_storage.bucket
    }
    
  }
}

resource "aws_cloudwatch_log_group" "image_recog_log" {
  name              = "/aws/lambda/image_recog-analysis"
  retention_in_days = 14
}