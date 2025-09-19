terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws     = { source = "hashicorp/aws", version = "~> 5.0" }
    archive = { source = "hashicorp/archive", version = "~> 2.4" }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_dynamodb_table" "resume" {
  name = "resume-p"
}

# ==========  IAM  ==========
data "aws_iam_policy_document" "lambda_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "resume-website-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
}

data "aws_iam_policy_document" "policy_all" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:UpdateItem",
      "dynamodb:GetItem",
      "dynamodb:PutItem"
    ]
    resources = [data.aws_dynamodb_table.resume.arn]
  }

  statement {
    effect    = "Allow"
    actions   = ["ses:SendEmail", "ses:SendRawEmail"]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "policy_all" {
  name   = "resume-website-policy"
  policy = data.aws_iam_policy_document.policy_all.json
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.policy_all.arn
}

data "archive_file" "visitor_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_visitor"
  output_path = "${path.module}/visitor_lambda.zip"
}

data "archive_file" "contact_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_contact"
  output_path = "${path.module}/contact_lambda.zip"
}

resource "aws_lambda_function" "visitor" {
  function_name = "resume-visitor-counter"
  runtime       = "python3.11"
  handler       = "lambda_function.lambda_handler"
  role          = aws_iam_role.lambda_role.arn

  filename         = data.archive_file.visitor_zip.output_path
  source_code_hash = data.archive_file.visitor_zip.output_base64sha256

  environment {
    variables = {
      TABLE_NAME = data.aws_dynamodb_table.resume.name
      PK_NAME    = "id"   
      ITEM_ID    = "key"  
      VIEW_ATTR  = "view" 
    }
  }
}

resource "aws_lambda_function" "contact" {
  function_name = "resume-contact-form"
  runtime       = "python3.11"
  handler       = "contact_lambda.lambda_handler"
  role          = aws_iam_role.lambda_role.arn

  filename         = data.archive_file.contact_zip.output_path
  source_code_hash = data.archive_file.contact_zip.output_base64sha256

  environment {
    variables = {
      CONTACT_TO   = var.contact_to
      CONTACT_FROM = var.contact_from
    }
  }
}

resource "aws_apigatewayv2_api" "api" {
  name          = "resume-website-api"
  protocol_type = "HTTP"
  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["GET", "POST", "OPTIONS"]
    allow_headers = ["*"]
  }
}

resource "aws_apigatewayv2_integration" "counter_inte" {
  api_id                 = aws_apigatewayv2_api.api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.visitor.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "counter_route" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "GET /counter"
  target    = "integrations/${aws_apigatewayv2_integration.counter_inte.id}"
}

resource "aws_lambda_permission" "allow_apigw_counter" {
  statement_id  = "AllowAPIGatewayInvokeCounter"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.visitor.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}

resource "aws_apigatewayv2_integration" "contact_inte" {
  api_id                 = aws_apigatewayv2_api.api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.contact.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "contact_route" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "POST /contact"
  target    = "integrations/${aws_apigatewayv2_integration.contact_inte.id}"
}

resource "aws_lambda_permission" "allow_apigw_contact" {
  statement_id  = "AllowAPIGatewayInvokeContact"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.contact.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_sesv2_email_identity" "from_email" {
  email_identity = var.contact_from
}

resource "aws_sesv2_email_identity" "to_email" {
  email_identity = var.contact_to
}

output "visitor_api_url" {
  value = "${aws_apigatewayv2_api.api.api_endpoint}/counter"
}
output "contact_api_url" {
  value = "${aws_apigatewayv2_api.api.api_endpoint}/contact"
}
