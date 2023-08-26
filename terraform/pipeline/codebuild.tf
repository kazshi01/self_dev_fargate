# TERRAFORM PLAN
resource "aws_codebuild_project" "terraform_plan" {
  name          = "terraform-plan-project"
  description   = "Terraform Plan"
  build_timeout = 5
  service_role  = aws_iam_role.codebuild_role.arn

  cache {
    type = "NO_CACHE"
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  source {
    type      = "CODEPIPELINE"
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

  cache {
    type = "NO_CACHE"
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  source {
    type      = "CODEPIPELINE"
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

