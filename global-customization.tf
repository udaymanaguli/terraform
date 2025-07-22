variable "management_account_id" {
  description = "AWS Account ID of the management account"
  type        = string
}

variable "management_role_name" {
  description = "IAM Role in the management account allowed to assume this role"
  type        = string
}

# Allow sts:AssumeRole from the management account's IAM role
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [
        "arn:aws:iam::${var.management_account_id}:role/${var.management_role_name}"
      ]
    }
  }
}

# IAM Role in the member account
resource "aws_iam_role" "cloudtrail_readonly_role" {
  name               = "CrossAccountCloudTrailReadOnlyRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# CloudTrail read-only permissions
data "aws_iam_policy_document" "cloudtrail_readonly_policy" {
  statement {
    effect = "Allow"
    actions = [
      "cloudtrail:DescribeTrails",
      "cloudtrail:GetTrailStatus",
      "cloudtrail:LookupEvents",
      "cloudtrail:ListTrails",
      "cloudtrail:GetEventSelectors",
      "cloudtrail:GetInsightSelectors"
    ]
    resources = ["*"]
  }
}

# Create a policy
resource "aws_iam_policy" "cloudtrail_readonly_policy" {
  name   = "CloudTrailReadOnlyPolicy"
  policy = data.aws_iam_policy_document.cloudtrail_readonly_policy.json
}

# Attach policy to the role
resource "aws_iam_role_policy_attachment" "attach_cloudtrail_policy" {
  role       = aws_iam_role.cloudtrail_readonly_role.name
  policy_arn = aws_iam_policy.cloudtrail_readonly_policy.arn
}
