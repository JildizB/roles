resource "aws_iam_role" "StageAccessRole" {
  name = "StageAccessRole1"

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
resource "aws_iam_policy" "writeEC2" {
  name = "writeEC21"
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:TerminateInstances",
          "ec2:RunInstances",
          "ec2:StartInstances",
          "ec2:RebootInstances",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
resource "aws_iam_policy" "StagefullEKS" {
  name = "StagefullEKS1"
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "eks:*",
        ],
        "Resource" : "*"
      }
    ]
  })
}
resource "aws_iam_policy" "StagereadS3" {
  name = "StagereadS31"
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:Get*",
          "s3:List*",
          "s3:Describe*"
        ],
        "Resource" : "*"
      }
    ]
  })
}
resource "aws_iam_policy_attachment" "StagewriteEC2-attach" {
  name       = "ProdreadEC2-attach"
  roles      = [aws_iam_role.StageAccessRole.name]
  policy_arn = aws_iam_policy.writeEC2.arn
}

resource "aws_iam_policy_attachment" "StagefullEKS-attach" {
  name       = "ProdreadEKS-attach"
  roles      = [aws_iam_role.StageAccessRole.name]
  policy_arn = aws_iam_policy.StagefullEKS.arn
}

resource "aws_iam_policy_attachment" "StagereadS3-attach" {
  name       = "ProdreadS3-attach"
  roles      = [aws_iam_role.StageAccessRole.name]
  policy_arn = aws_iam_policy.StagereadS3.arn
}
