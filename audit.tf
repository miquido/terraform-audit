resource "aws_budgets_budget" "monthly_cost_budget" {
  name         = "${var.project}-${var.environment}-monthly-cost-budget"
  budget_type  = "COST"
  limit_amount = var.monthly_budget
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator = "GREATER_THAN"
    notification_type   = "FORECASTED"
    threshold = 100
    threshold_type      = "PERCENTAGE"
    subscriber_sns_topic_arns = [var.sns_arn]
  }

  notification {
    comparison_operator = "GREATER_THAN"
    notification_type   = "ACTUAL"
    threshold           = 90
    threshold_type      = "PERCENTAGE"
    subscriber_sns_topic_arns = [var.sns_arn]
  }
}

resource "aws_s3_bucket" "cloudtrail_bucket" {
  bucket = lower("${var.project}-${var.environment}-audit-cloudtrail")
}

resource "aws_s3_bucket_policy" "cloudtrail_policy" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AWSCloudTrailBucketPermissionsCheck"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = aws_s3_bucket.cloudtrail_bucket.arn
      },
      {
        Sid    = "AWSConfigBucketDelivery"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.cloudtrail_bucket.arn}/AWSLogs/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}

resource "aws_cloudtrail" "management_events" {
  provider                      = aws.us-east-1
  name                          = lower("${var.project}-${var.environment}-management-events")
  s3_bucket_name                = aws_s3_bucket.cloudtrail_bucket.id
  include_global_service_events = true
  is_multi_region_trail         = false
  enable_log_file_validation    = true

  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }

  depends_on = [aws_s3_bucket_policy.cloudtrail_policy]
}

resource "aws_cloudwatch_event_rule" "root_sign_in" {
  provider    = aws.us-east-1
  name        = "${var.project}-${var.environment}-RootActivityRule"
  description = "Events rule for monitoring root AWS Console Sign In activity"
  event_pattern = jsonencode({
    "detail-type" : ["AWS Console Sign In via CloudTrail"],
    "detail" : {
      "userIdentity" : {
        "type" : ["Root"]
      }
    }
  })
}

resource "aws_cloudwatch_event_target" "root_sign_in_sns" {
  provider  = aws.us-east-1
  rule      = aws_cloudwatch_event_rule.root_sign_in.name
  target_id = "RootActivitySNSTopic"
  arn       = var.sns_virginia_arn
}

resource "aws_cloudwatch_event_rule" "iam_changes" {
  count = var.enable_iam_changes ? 1 : 0
  provider    = aws.us-east-1
  name        = "${var.project}-${var.environment}-IAMChangeRule"
  description = "Events rule for monitoring IAM changes"
  event_pattern = jsonencode({
    "source": ["aws.iam"],
    "detail-type": ["AWS API Call via CloudTrail"]
  })
}

resource "aws_cloudwatch_event_target" "iam_changes_sns" {
  count = var.enable_iam_changes ? 1 : 0
  provider  = aws.us-east-1
  rule      = aws_cloudwatch_event_rule.iam_changes[count.index].name
  target_id = "IAMChangeSNSTopic"
  arn       = var.sns_virginia_arn
}