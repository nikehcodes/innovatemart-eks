# Developer Read-Only Role
resource "aws_iam_role" "developer_readonly" {
  name = "EKSDeveloperReadOnly"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
      }
    ]
  })

  tags = var.common_tags
}

# Developer Read-Only User
resource "aws_iam_user" "developer_readonly" {
  name = "developer-readonly"
  path = "/"

  tags = var.common_tags
}

resource "aws_iam_user_policy" "developer_readonly" {
  name = "EKSReadOnlyPolicy"
  user = aws_iam_user.developer_readonly.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Resource = aws_iam_role.developer_readonly.arn
      }
    ]
  })
}

resource "aws_iam_access_key" "developer_readonly" {
  user = aws_iam_user.developer_readonly.name
}

data "aws_caller_identity" "current" {}
