# Lambda Shutdown EC2 Terraform

This Terraform will provision a scheduled Lambda function to shut down EC2s across all available regions (with the exception of regions you define to skip) that do not have a tag attached to them to keep running.

## Variables

| Variable | Description | Default |
|---|---|---|
| skip_regions | Comma-separated list of regions to skip. | '' |
| running_tag | AWS Tag set to 'true' to indicate instances that should keep running. | KeepRunning |
| cron_schedule | AWS cron schedule to execute the Lambda function (in UTC, defaults to 3AM). | 0 3 * * ? * |

## Usage

1. In the root of this directory, run `terraform plan` with your any variables to overwrite and validate the output:

```bash
terraform plan --set skip_regions=us-east-1,us-east-2
```

2. If the output looks correct, run `terraform apply` with the same overwritten variables, typing `yes` when prompted:

```bash
terraform apply --set skip_regions=us-east-1,us-east-2
```