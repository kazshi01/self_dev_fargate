# TERRAFORM PLAN
resource "aws_codebuild_project" "terraform_plan" {
  name          = "terraform-plan-project"
  description   = "Terraform Plan"
  build_timeout = 5
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "TERRAFORM_ACTION"
      value = "plan"
    }
  }

  source {
    type = "CODEPIPELINE"
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

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "TERRAFORM_ACTION"
      value = "apply"
    }
  }

  source {
    type = "CODEPIPELINE"
  }
}

