resource "aws_iam_role" "ProdDeveloperAccessRole" {
  name = "ProdDeveloperAccessRole"

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
resource "aws_iam_policy" "ProdreadEC2" {
  name = "ProdreadEC2"
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

resource "aws_iam_policy" "ProdreadEKS" {
  name = "ProdreadEKS"
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
resource "aws_iam_policy" "ProdreadS3" {
  name = "ProdreadS3"
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
resource "aws_iam_policy_attachment" "ProdreadEC2-attach" {
  name       = "ProdreadEC2-attach"
  roles      = [aws_iam_role.ProdDeveloperAccessRole.name]
  policy_arn = aws_iam_policy.ProdreadEC2.arn
}

resource "aws_iam_policy_attachment" "ProdreadEKS-attach" {
  name       = "ProdreadEKS-attach"
  roles      = [aws_iam_role.ProdDeveloperAccessRole.name]
  policy_arn = aws_iam_policy.ProdreadEKS.arn
}

resource "aws_iam_policy_attachment" "ProdreadS3-attach" {
  name       = "ProdreadS3-attach"
  roles      = [aws_iam_role.ProdDeveloperAccessRole.name]
  policy_arn = aws_iam_policy.ProdreadS3.arn
}
