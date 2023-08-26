# IAM Role for CodeBuild
resource "aws_iam_role" "codebuild_role" {
  name = "codebuild-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Role for CodePipeline
resource "aws_iam_role" "codepipeline_role" {
  name = "codepipeline-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      }
    ]
  })
}

data "aws_iam_policy_document" "codepipeline_s3_policy" {
  statement {
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::self-dev-marukome/codepipeline/fargate/*"]
  }
}

resource "aws_iam_policy" "codepipeline_s3" {
  name   = "codepipeline_s3_policy"
  policy = data.aws_iam_policy_document.codepipeline_s3_policy.json
}

resource "aws_iam_role_policy_attachment" "codepipeline_s3_attachment" {
  policy_arn = aws_iam_policy.codepipeline_s3.arn
  role       = aws_iam_role.codepipeline_role.name
}

resource "aws_iam_policy" "codepipeline_policy" {
  name        = "codepipeline-policy"
  description = "Policy for CodePipeline to access CodeCommit and start CodeBuild"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "codecommit:GetBranch",
          "codecommit:GetCommit",
          "codecommit:UploadArchive",
          "codecommit:GetUploadArchiveStatus",
          "codecommit:CancelUploadArchive",
          "codebuild:StartBuild", # Add this action to allow CodePipeline to start CodeBuild
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codepipeline_policy_attachment" {
  policy_arn = aws_iam_policy.codepipeline_policy.arn
  role       = aws_iam_role.codepipeline_role.name
}

