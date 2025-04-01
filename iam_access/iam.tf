provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "test_role" {
  name = "terraform_role"

  # Corrected assume role policy without 'Resource'
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    tag-key = "ec2-s3 full access"
  }
}



resource "aws_iam_policy_attachment" "test-atach" {
    name       = "test-atach"
    policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
    roles      = [aws_iam_role.test_role.name]
  
}