# Generate username: "first_name.last_initial"
locals {
  username = lower("${var.first_name}.${substr(var.last_name, 0, 1)}")
}

# Create IAM User
resource "aws_iam_user" "user" {
  name = local.username
}

# Create IAM Group (only if it doesn’t exist)
resource "aws_iam_group" "group" {
  name = var.group_name
}

# Assign user to the group
resource "aws_iam_group_membership" "group_membership" {
  name  = "${local.username}_group_membership"
  group = aws_iam_group.group.name
  users = [aws_iam_user.user.name]
}

# Create IAM Policy from external JSON file using File() Function
resource "aws_iam_policy" "policy" {
  name        = "EC2_VPC_Full_Access"
  description = "Grants EC2 and VPC full access, except delete actions"
  policy      = file(var.policy_file_path) 
  }

# Attach Policy to the Group
resource "aws_iam_policy_attachment" "group_policy_attachment" {
  name       = "EC2_VPC_Group_Attachment"
  policy_arn = aws_iam_policy.policy.arn
  groups     = [aws_iam_group.group.name]
}