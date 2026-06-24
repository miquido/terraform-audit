# audit <a href="https://miquido.com"><img align="right" src="https://cdn.miquido.dev/miquido-logo.png" width="150" /></a>

Terraform module that sets up AWS audit baseline: CloudTrail, budget alerts, and CloudWatch Events rules for root sign-in and IAM changes.

## Development

```bash
make init   # run once after cloning
make readme # regenerate README.md
make lint   # lint terraform code
```

## Usage

```hcl
module "audit" {
  source = "git@gitlab.miquido.com:miquido/terraform/audit.git"

  project          = "myproject"
  environment      = "prod"
  sns_arn          = aws_sns_topic.alerts.arn
  sns_virginia_arn = aws_sns_topic.alerts_virginia.arn
  monthly_budget   = 1000
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_aws.us-east-1"></a> [aws.us-east-1](#provider\_aws.us-east-1) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [aws_budgets_budget.monthly_cost_budget](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/budgets_budget) | resource |
| [aws_cloudtrail.management_events](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail) | resource |
| [aws_cloudwatch_event_rule.iam_changes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_rule.root_sign_in](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.iam_changes_sns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_event_target.root_sign_in_sns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_s3_bucket.cloudtrail_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.cloudtrail_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_enable_iam_changes"></a> [enable\_iam\_changes](#input\_enable\_iam\_changes) | Enable CloudWatch Events rule for monitoring IAM changes via CloudTrail | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (e.g. dev, staging, prod) | `string` | n/a | yes |
| <a name="input_monthly_budget"></a> [monthly\_budget](#input\_monthly\_budget) | max USD account cost for reached budget notifications | `number` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Project name used as a prefix for resource names | `string` | n/a | yes |
| <a name="input_sns_arn"></a> [sns\_arn](#input\_sns\_arn) | ARN of the SNS topic for budget notifications (regional) | `string` | n/a | yes |
| <a name="input_sns_virginia_arn"></a> [sns\_virginia\_arn](#input\_sns\_virginia\_arn) | ARN of the SNS topic in us-east-1 for CloudWatch Events notifications | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## License

[MIT](LICENSE)
