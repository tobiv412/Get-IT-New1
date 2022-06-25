# POLICY DOC - ASSUME ROLE FOR LAMBDA
data "aws_iam_policy_document" "lambda_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# # POLICY DOC - ASSUME ROLE FOR STEP MACHINES
# data "aws_iam_policy_document" "sm_assume_policy" {
#   statement {
#     actions = ["sts:AssumeRole"]

#     principals {
#       type        = "Service"
#       identifiers = ["states.amazonaws.com"]
#     }
#   }
# }

# POLICY DOC - ALLOW LAMBDA TO USE rekognition
data "aws_iam_policy_document" "lambda_for_rekognition" {
  statement {
    sid = "Lambdarekognition"

    actions = [
      "rekognition:*"
    ]

    resources = [
      "*"
    ]
  }
}

data "aws_iam_policy_document" "lambda_store_image" {
  statement {
    sid = "s3StoreImage"

    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject"
    ]

    resources = [
      "arn:aws:s3:::image-rekognition-storage-demo",
      "arn:aws:s3:::image-rekognition-storage-demo/*"
    ]
  }
}

# # POLICY DOC - ACCESS LAMBDA FUNCTION FROM SM
# data "aws_iam_policy_document" "sm_access_to_lambda" {
#   statement {
#     sid = "SMForLambda"

#     actions = [
#       "lambda:InvokeFunction"
#     ]

#     resources = [
#       aws_lambda_function.sentiment_analysis.arn
#     ]
#   }
# }

# POLICY DOC - ACCESS TO S3 STATIC HOSTING
data "aws_iam_policy_document" "s3_static_host" {
  statement {
    sid = "s3StaticHost"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject"
    ]

    resources = [
      "arn:aws:s3:::image-rekognition-website-demo",
      "arn:aws:s3:::image-rekognition-website-demo/*"
    ]
  }
}

# POLICY DOC - LAMBDA to log cloudwatch
data "aws_iam_policy_document" "lambda_logs" {
  statement {
    sid = "sentimentLambdaLog"

    actions = [
      "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }
}

# POLICY RESSOURCE - LET SM INVOKE LAMBDA
resource "aws_iam_policy" "lambda_for_rekognition" {
  name        = "lambda-for-rekognition"
  description = "Allow Lambda Function to use rekognition"

  policy = data.aws_iam_policy_document.lambda_for_rekognition.json
}

# # POLICY RESSOURCE - LET SM INVOKE LAMBDA
# resource "aws_iam_policy" "sm_access_to_lambda" {
#   name        = "sm-access-to-lambda"
#   description = "Allow State Machines to execute Lambda"

#   policy = data.aws_iam_policy_document.sm_access_to_lambda.json
# }

# POLICY RESSOURCE - LAMBDA to log cloudwatch
resource "aws_iam_policy" "lambda_logs" {
  name        = "lambda-logs"
  description = "Allow Lambda to logs to cloudwatch"

  policy = data.aws_iam_policy_document.lambda_logs.json
}

resource "aws_iam_policy" "lambda_store_image" {
  name        = "lambda-store-image"
  description = "Allow Lambda to store image to s3"

  policy = data.aws_iam_policy_document.lambda_store_image.json
}

# IAM ROLE - LAMBDA EXECUTION
resource "aws_iam_role" "lambda_role" {
  name               = "sentiment-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_policy.json
}

# # IAM ROLE - STEP FUNCTIONS FOR STATE MACHINES
# resource "aws_iam_role" "states_role" {
#   name               = "sentiment-states-role"
#   assume_role_policy = data.aws_iam_policy_document.sm_assume_policy.json
# }

# ATTACH - POLICY TO ROLE - rekognition FOR LAMBDA
resource "aws_iam_role_policy_attachment" "lambda_for_rekognition_attch" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_for_rekognition.arn
}

# # ATTACH - POLICY TO ROLE - SM FOR LAMBDA
# resource "aws_iam_role_policy_attachment" "sm_lambda_attch" {
#   role       = aws_iam_role.states_role.name
#   policy_arn = aws_iam_policy.sm_access_to_lambda.arn
# }

# ATTACH - POLICY TO ROLE - LOGS FOR LAMBDA
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_logs.arn
}

resource "aws_iam_role_policy_attachment" "lambda_store_image" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_store_image.arn
}