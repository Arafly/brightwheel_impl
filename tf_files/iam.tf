# This Terraform code does the following:
# - Creates IAM groups for each engineering team, 
# - IAM roles for each environment
# - Assigns policies to each group and role. 
# The policies are based on the access requirements specified in the problem statement.

# Additional assumptions made in this implementation include:

# The AWS provider is configured with the appropriate region.
# The necessary AWS credentials are available to the Terraform code.
# The IAM policies specified in the problem statement exist in the AWS account being used.


provider "aws" {
  region = "us-west-2"
}


# Create IAM group for each engineering team
resource "aws_iam_group" "engineering_group" {
  for_each = toset(["frontend", "backend", "data", "sre"])
  name     = "${each.value}-engineering-group"
}

# Create IAM roles for each environment
resource "aws_iam_role" "role" {
  for_each = toset(["dev", "qa", "prod"])
  name     = "${each.value}-role"
}

# Assign policies to each IAM group
resource "aws_iam_group_policy_attachment" "frontend_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonCloudFrontReadOnlyAccess"
  group      = aws_iam_group.frontend_engineering_group.name
}

resource "aws_iam_group_policy_attachment" "backend_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterReadOnlyAccess"
  group      = aws_iam_group.backend_engineering_group.name
}

resource "aws_iam_group_policy_attachment" "data_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonRedshiftReadOnlyAccess"
  group      = aws_iam_group.data_engineering_group.name
}

resource "aws_iam_group_policy_attachment" "sre_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  group      = aws_iam_group.sre_group.name
}

# Assign IAM roles to each environment
resource "aws_iam_role_policy_attachment" "role_policy" {
  for_each = toset(["dev", "qa", "prod"])
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  role       = aws_iam_role.role[each.key].name
}