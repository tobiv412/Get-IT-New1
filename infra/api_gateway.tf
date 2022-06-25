resource "aws_apigatewayv2_api" "lambda" {
  name          = "detect_gw"
  protocol_type = "HTTP"
  cors_configuration {
    allow_origins = [ 
      "http://image-rekognition-website-demo.s3-website-eu-west-1.amazonaws.com/",
      "http://image-rekognition-website-demo.s3-website-eu-west-1.amazonaws.com"
    ]
    allow_methods = ["POST", "GET", "OPTIONS"]
    allow_headers = ["content-type"]
  }
}

resource "aws_apigatewayv2_stage" "lambda" {
  api_id = aws_apigatewayv2_api.lambda.id

  name        = "detect_gw_stage"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

resource "aws_apigatewayv2_integration" "detect" {
  api_id = aws_apigatewayv2_api.lambda.id

  integration_uri    = aws_lambda_function.image_recog_analysis.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"

  request_parameters = {
    "overwrite:querystring.image_base64" = "$request.querystring.image_base64"
  }
}

resource "aws_apigatewayv2_route" "detect" {
  api_id = aws_apigatewayv2_api.lambda.id

  route_key = "POST /detect"
  target    = "integrations/${aws_apigatewayv2_integration.detect.id}"
}

resource "aws_cloudwatch_log_group" "api_gw" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.lambda.name}"

  retention_in_days = 30
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.image_recog_analysis.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}

# curl -X POST -H "Content-Type: application/json" -d '{"image" : $base64_image}' "$(terraform output -raw base_url)/detect"
# (echo -n '{"image": "'; base64 ./Talent-Academy-logo.png; echo '"}') | curl -H "Content-Type: application/json" -d @-  "$(terraform output -raw base_url)/detect"

