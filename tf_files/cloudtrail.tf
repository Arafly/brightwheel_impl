# Define the AWS provider
provider "aws" {
  region = "us-east-1"
}

# Create an AWS Config Recorder
resource "aws_config_configuration_recorder" "example" {
  name = "brightwheel-recorder"

  recording_group {
    all_supported = true
  }

  # Specify the Amazon S3 bucket that AWS Config delivers configuration snapshots to

  s3 {
    bucket = "brightwheel--bucket"
    prefix = "brightwheel--prefix"
  }
}

# Create an IAM role for AWS Config
resource "aws_iam_role" "example_config" {
  name = "brightwheel-config-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "config.amazonaws.com"
        }
      }
    ]
  })
}

# Attach a policy to the IAM role to grant AWS Config permissions to read resources
resource "aws_iam_role_policy_attachment" "brightwheel-_config" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
  role       = aws_iam_role.brightwheel_config.name
}

# Create an AWS Config rule
resource "aws_config_config_rule" "brightwheel" {
  name = "brightwheel-rule"

  # Specify the resource types to evaluate compliance against
  scope {
    compliance_resource_types = [
      "AWS::EC2::Instance",
      "AWS::Redshift::Cluster",
      "AWS::EKS::Cluster",
      "AWS::CloudFront::Distribution"
    ]
  }

}
