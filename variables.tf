variable "project" {}
variable "environment" {}
variable "sns_arn" {}
variable "sns_virginia_arn" {}

variable "monthly_budget" {
  type    = number
  description = "max USD account cost for reached budget notifications"
}

variable "enable_iam_changes" {
  type = bool
  default = true
}
