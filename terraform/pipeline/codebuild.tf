# TERRAFORM PLAN
resource "aws_codebuild_project" "terraform_plan" {
  name          = "terraform-plan-project"
  description   = "Terraform Plan"
  build_timeout = 5
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  source {
    type      = "CODEPIPELINE"
    location  = "https://git-codecommit.ap-northeast-1.amazonaws.com/v1/repos/self_dev_fargate_repo"
    buildspec = "buildspec-plan.yml"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "ubuntu:latest"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "TERRAFORM_ACTION"
      value = "plan"
    }
  }
}

# TERRAFORM APPLY
resource "aws_codebuild_project" "terraform_apply" {
  name          = "terraform-apply-project"
  description   = "Terraform Apply"
  build_timeout = 5
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  source {
    type      = "CODEPIPELINE"
    location  = "https://git-codecommit.ap-northeast-1.amazonaws.com/v1/repos/self_dev_fargate_repo"
    buildspec = "buildspec-apply.yml"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "ubuntu:latest"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "TERRAFORM_ACTION"
      value = "apply"
    }
  }
}

