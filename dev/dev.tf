#This is role for Developers
resource "aws_iam_role" "DeveloperAccessRole" {
  name = "DeveloperAccessRole"

  #Permission are written in JSON - can be found in AWS
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

#This is my Read permissions on all EC2 instances policy
resource "aws_iam_policy" "readEC2" {
  name = "readEC2"
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Get*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
#This is my EKS read policy
resource "aws_iam_policy" "readEKS" {
  name = "readEKS"
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "eks:Describe*",
        ],
        "Resource" : "*"
      }
    ]
  })
}
#This is my S3 admin policy
resource "aws_iam_policy" "fullS3" {
  name = "fullS3"
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:*"
        ],
        "Resource" : "*"
      }
    ]
  })
}
#This is an attachment of policy to the role
resource "aws_iam_policy_attachment" "ec2-attach" {
  name       = "ec2-attach"
  roles      = [aws_iam_role.DeveloperAccessRole.name]
  policy_arn = aws_iam_policy.readEC2.arn
}

resource "aws_iam_policy_attachment" "eks-attach" {
  name       = "eks-attach"
  roles      = [aws_iam_role.DeveloperAccessRole.name]
  policy_arn = aws_iam_policy.readEKS.arn
}

resource "aws_iam_policy_attachment" "s3-attach" {
  name       = "s3-attach"
  roles      = [aws_iam_role.DeveloperAccessRole.name]
  policy_arn = aws_iam_policy.fullS3.arn
}
