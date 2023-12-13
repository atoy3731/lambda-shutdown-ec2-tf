data "archive_file" "python_lambda_package" {  
  type = "zip"  
  source_file = "${path.module}/code/lambda_function.py" 
  output_path = "shutdown.zip"
}

resource "aws_lambda_function" "lambda_function" {
  function_name = "shutdown"
  filename      = "shutdown.zip"
  source_code_hash = data.archive_file.python_lambda_package.output_base64sha256
  role          = aws_iam_role.lambda_role.arn
  runtime       = "python3.8"
  handler       = "lambda_function.lambda_handler"
  timeout       = 120

  environment {
    variables = {
      PYTHONUNBUFFERED = "1"
      RUNNING_TAG = var.running_tag
      SKIP_REGIONS = var.skip_regions
    }
  }

}