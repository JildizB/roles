resource "aws_iam_role" "StageDevopsAccessRole" {
  name = "StageDevopsAccessRole1"

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
#This is my EKS read policy
resource "aws_iam_policy" "fullIAM" {
  name = "fullIAM1"
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : "iam:*",
        "Resource" : "*"
      }
    ]
    }
  )
}

resource "aws_iam_policy" "StagereadEC2" {
  name = "StagereadEC21"
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
resource "aws_iam_policy" "StagefullS3" {
  name = "StagefullS31"
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

resource "aws_iam_policy_attachment" "StagefullIAM-attach" {
  name       = "admin_no_secret-attach"
  roles      = [aws_iam_role.StageDevopsAccessRole.name]
  policy_arn = aws_iam_policy.fullIAM.arn
}

resource "aws_iam_policy_attachment" "StagereadEC2-attach" {
  name       = "ProdfullEC2-attach"
  roles      = [aws_iam_role.StageDevopsAccessRole.name]
  policy_arn = aws_iam_policy.StagereadEC2.arn
}
resource "aws_iam_policy_attachment" "StagefullS3-attach" {
  name       = "ProdfullEC2-attach"
  roles      = [aws_iam_role.StageDevopsAccessRole.name]
  policy_arn = aws_iam_policy.StagefullS3.arn
}
