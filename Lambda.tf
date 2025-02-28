resource "aws_lambda_function" "update_html_lambda" {
  filename      = "lambda_functions.zip"  
  function_name = "UpdateHtmlLambda"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "lambda_function.lambda_handler"  
  runtime       = "python3.9"

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.html_bucket.bucket
      TABLE_NAME  = aws_dynamodb_table.dynamic_string_table.name
    }
  }
}

resource "aws_lambda_permission" "api_gateway_invoke" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.update_html_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.dynamic_string_api.execution_arn}/*/*/*"
}