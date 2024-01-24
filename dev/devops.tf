###This is DevOps access role with admin permissions

#This is role for Developers
resource "aws_iam_role" "DevopsAccessRole" {
  name = "DevopsAccessRole"

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

#This is admin policy

resource "aws_iam_policy" "admin_policy" {
  name = "admin_policy"
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
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "admin-attach" {
  name       = "admin-attach"
  roles      = [aws_iam_role.DevopsAccessRole.name]
  policy_arn = aws_iam_policy.admin_policy.arn
}
