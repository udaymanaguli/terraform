## For account-customization :

# EC2 Tag Enforcer with Lambda and Terraform

This project automatically stops any **running EC2 instances** that are **missing a required tag** (like `"Owner"`).  
It uses **Terraform** to deploy an **AWS Lambda function** and **CloudWatch Events** for scheduled execution.

---

# Use Case

In AWS environments, it's critical to tag resources for cost allocation, ownership, and security.  
This automation enforces tagging by stopping instances without the required tag, helping you:

- Reduce unexpected costs
- Improve security hygiene
- Enforce compliance

---

- Terraform:
  - Zips `tag_checker.py`
  - Creates Lambda function
  - Assigns IAM role with EC2 permissions
  - Creates CloudWatch rule to trigger every 6 hours
- Lambda:
  - Lists all running EC2 instances
  - Stops instances that are missing the `"Owner"` tag

---




## For Global customization :

# Cross-Account CloudTrail ReadOnly Role (Terraform)

This Terraform module creates an IAM Role in a **member AWS account** that allows a specific IAM Role in the **management account** to assume it and **read CloudTrail** logs.

---

# Use Case

- Centralized **CloudTrail monitoring** from the management account
- Allows security/DevOps teams in the master account to view event history and audit trails across member accounts
- Implements **least privilege** using custom policy

---

# Resources Created

1. IAM Role: `CrossAccountCloudTrailReadOnlyRole`
2. Assume Role Policy: Allows specified IAM Role in management account to assume
3. Custom IAM Policy: CloudTrail read-only access
4. Policy Attachment: Attaches policy to the role

---

# Permissions Granted to Role

The role allows the following CloudTrail actions:

```json
[
  "cloudtrail:DescribeTrails",
  "cloudtrail:GetTrailStatus",
  "cloudtrail:LookupEvents",
  "cloudtrail:ListTrails",
  "cloudtrail:GetEventSelectors",
  "cloudtrail:GetInsightSelectors"
]
