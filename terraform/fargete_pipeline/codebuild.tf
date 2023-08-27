resource "aws_codebuild_project" "ecr_push" {
  name          = "ecr-push-project"
  description   = "ECR Push CodeBuild Project"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type           = "CODEPIPELINE"
    namespace_type = "NONE"
    name           = "imagedefinitions.json"
    packaging      = "NONE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:5.0"
    type         = "LINUX_CONTAINER"
    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = var.region
    }
  }

  source {
    type            = "CODECOMMIT"
    location        = "https://git-codecommit.ap-northeast-1.amazonaws.com/v1/repos/self_dev_fargate_repo"
    git_clone_depth = 1
    buildspec       = "buildspec.yml"
  }
}

