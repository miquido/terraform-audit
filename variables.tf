variable "project" {
  type        = string
  description = "Project name used as a prefix for resource names"
}

variable "environment" {
  type        = string
  description = "Environment name (e.g. dev, staging, prod)"
}

variable "sns_arn" {
  type        = string
  description = "ARN of the SNS topic for budget notifications (regional)"
}

variable "sns_virginia_arn" {
  type        = string
  description = "ARN of the SNS topic in us-east-1 for CloudWatch Events notifications"
}

variable "monthly_budget" {
  type        = number
  description = "max USD account cost for reached budget notifications"
}

variable "enable_iam_changes" {
  type        = bool
  default     = true
  description = "Enable CloudWatch Events rule for monitoring IAM changes via CloudTrail"
}
