resource "aws_codebuild_project" "ecr_push" {
  name          = "ecr-push-project"
  description   = "ECR Push CodeBuild Project"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:5.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = var.region
    }
    environment_variable {
      name  = "APP_SPEC_BUCKET_PATH"
      value = "s3://${var.bucket_name}/appspec.yml"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "./terraform/fargate_pipeline/specfile/buildspec.yml"
  }
}

