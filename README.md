# Lambda Shutdown EC2 Terraform

This Terraform will provision a scheduled Lambda function to shut down EC2s across all available regions (with the exception of regions you define to skip) that do not have a tag attached to them to keep running.

## Variables

| Variable | Description | Default |
|---|---|---|
| skip_regions | Comma-separated list of regions to skip. | '' |
| running_tag | AWS Tag set to 'true' to indicate instances that should keep running. | KeepRunning |
| cron_schedule | AWS cron schedule to execute the Lambda function (in UTC, defaults to 3AM). | 0 3 * * ? * |

## Usage

1. (Optional but Recommended) If you want to store your Terraform state in a remote S3 bucket (highly recommended), copy the `backend.tf.template` file to `backend.tf` and update the values to a unique S3 bucket and the respective region you're using before moving ahead.

2. On your first run, initialize Terraform:
```bash
terraform init
```

3. In the root of this directory, run `terraform plan` with your any variables to overwrite and validate the output, for example:

```bash
terraform plan --set skip_regions=us-east-1,us-east-2
```

4. If the output looks correct, run `terraform apply` with the same overwritten variables, typing `yes` when prompted, for example:

```bash
terraform apply --set skip_regions=us-east-1,us-east-2
```