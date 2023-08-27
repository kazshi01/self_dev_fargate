resource "aws_codepipeline" "codepipeline" {
  name     = "terraform-fargate-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = "self-dev-marukome"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name     = "Source"
      category = "Source"
      owner    = "AWS"
      provider = "CodeCommit"
      version  = "1"

      configuration = {
        RepositoryName = "self_dev_fargate_repo"
        BranchName     = "terraform_build"
      }

      output_artifacts = ["source_output"]
    }
  }

  stage {
    name = "Plan"

    action {
      name     = "Plan"
      category = "Build"
      owner    = "AWS"
      provider = "CodeBuild"
      version  = "1"

      input_artifacts = ["source_output"]

      configuration = {
        ProjectName = aws_codebuild_project.terraform_plan.name
      }

      output_artifacts = ["build_output"]
    }
  }

  stage {
    name = "ManualApproval"

    action {
      name     = "Approve"
      category = "Approval"
      owner    = "AWS"
      provider = "Manual"
      version  = "1"
    }
  }

  stage {
    name = "Apply"

    action {
      name     = "Apply"
      category = "Build"
      owner    = "AWS"
      provider = "CodeBuild"
      version  = "1"

      input_artifacts = ["build_output"]

      configuration = {
        ProjectName = aws_codebuild_project.terraform_apply.name
      }
    }
  }
}
