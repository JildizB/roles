#This is role for Developers
resource "aws_iam_role" "ProdDevopsAccessRole" {
  name = "ProdDevopsAccessRole"

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
resource "aws_iam_policy" "admin_no_secret" {
  name = "admin_no_secret"
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "*"
        ],
        "Resource" : "*"

      },
      {
        "Effect" : "Deny",
        "Action" : "secretsmanager:*",
        "Resource" : "*"
      }
    ]
  })
}
#This is my full permissions on all EC2 instances policy
resource "aws_iam_policy" "ProdfullEC2" {
  name = "ProdfullEC2"
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
#Attachment for second Role

resource "aws_iam_policy_attachment" "admin_no_secret-attach" {
  name       = "admin_no_secret-attach"
  roles      = [aws_iam_role.ProdDevopsAccessRole.name]
  policy_arn = aws_iam_policy.admin_no_secret.arn
}

resource "aws_iam_policy_attachment" "ProdfullEC2-attach" {
  name       = "ProdfullEC2-attach"
  roles      = [aws_iam_role.ProdDevopsAccessRole.name]
  policy_arn = aws_iam_policy.ProdfullEC2.arn
}
