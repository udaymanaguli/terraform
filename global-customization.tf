variable "management_account_id" {
  description = "AWS Account ID of the management (Org master) account"
  type        = string
}

variable "management_role_name" {
  description = "IAM Role in management account allowed to assume this role"
  type        = string
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.management_account_id}:role/${var.management_role_name}"]
    }
  }
}

resource "aws_iam_role" "org_readonly_role" {
  name               = "CrossAccountOrgReadOnlyRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "org_readonly_policy" {
  statement {
    effect    = "Allow"
    actions   = [
      "organizations:DescribeOrganization",
      "organizations:ListAccounts",
      "organizations:ListOrganizationalUnitsForParent",
      "organizations:ListRoots",
      "organizations:ListPolicies",
      "organizations:ListTargetsForPolicy"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "org_readonly_policy" {
  name   = "OrgReadOnlyAccess"
  policy = data.aws_iam_policy_document.org_readonly_policy.json
}

resource "aws_iam_role_policy_attachment" "attach_readonly_policy" {
  role       = aws_iam_role.org_readonly_role.name
  policy_arn = aws_iam_policy.org_readonly_policy.arn
}
