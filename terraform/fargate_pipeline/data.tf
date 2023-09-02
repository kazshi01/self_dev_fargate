data "terraform_remote_state" "fargate" {
  backend = "s3"
  config = {
    bucket = var.bucket_name
    key    = "github-actions/fargate"
    region = var.region
  }
}

locals {
  vpc_id                      = data.terraform_remote_state.fargate.outputs.vpc_id
  cluster_name                = data.terraform_remote_state.fargate.outputs.cluster_name
  service_name                = data.terraform_remote_state.fargate.outputs.service_name
  https_listener_arn          = data.terraform_remote_state.fargate.outputs.https_listener_arns[0]
  alb_target_group_blue       = data.terraform_remote_state.fargate.outputs.target_group_names[0]
  service_task_definition_arn = data.terraform_remote_state.fargate.outputs.service_task_definition_arn
  container_name              = data.terraform_remote_state.fargate.outputs.container_name
  container_port              = data.terraform_remote_state.fargate.outputs.container_port
}
