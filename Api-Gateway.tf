resource "aws_api_gateway_rest_api" "dynamic_string_api" {
  name = "DynamicStringAPI"
}

resource "aws_api_gateway_resource" "update_string_resource" {
  rest_api_id = aws_api_gateway_rest_api.dynamic_string_api.id
  parent_id   = aws_api_gateway_rest_api.dynamic_string_api.root_resource_id
  path_part   = "update"
}

resource "aws_api_gateway_method" "post_method" {
  rest_api_id   = aws_api_gateway_rest_api.dynamic_string_api.id
  resource_id   = aws_api_gateway_resource.update_string_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.dynamic_string_api.id
  resource_id             = aws_api_gateway_resource.update_string_resource.id
  http_method             = aws_api_gateway_method.post_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.update_html_lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.dynamic_string_api.id

  # Trigger deployment when the API Gateway or its resources change
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_rest_api.dynamic_string_api.body,
      aws_api_gateway_resource.update_string_resource.id,
      aws_api_gateway_method.post_method.http_method,
      aws_api_gateway_integration.lambda_integration.uri
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "prod" {
  stage_name    = "prod"
  rest_api_id   = aws_api_gateway_rest_api.dynamic_string_api.id
  deployment_id = aws_api_gateway_deployment.deployment.id

}