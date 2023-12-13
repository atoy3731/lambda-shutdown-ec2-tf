data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_permission_policy" {

  statement {
    effect = "Allow"
    actions = [
      "ec2:ModifyVolume",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:Describe*",
      "ec2:ImportVolume",
      "ec2:ModifyVolumeAttribute",
      "ec2:ImportKeyPair",
      "ec2:CreateKeyPair",
      "ec2:CreateSecurityGroup",
      "ec2:CreateTags",
      "ec2:DescribeVolumesModifications",
      "ec2:DeleteKeyPair",
      "ec2:EnableVolumeIO",
      "ec2:RebootInstances",
      "ec2:TerminateInstances",
      "ec2:StartInstances",
      "ec2:StopInstances",
      "ec2:RunInstances"
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "lambda-shutdown-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
  inline_policy {
    name   = "lambda-shutdown-policy"
    policy = data.aws_iam_policy_document.lambda_permission_policy.json
  }
}