data "terraform_remote_state" "fargate" {
  backend = "s3"
  config = {
    bucket = var.bucket_name
    key    = "github-actions/fargate/terraform.tfstate"
    region = var.region
  }
}

locals {
  vpc_id                = data.terraform_remote_state.fargate.outputs.vpc_id
  cluster_name          = data.terraform_remote_state.fargate.outputs.cluster_name
  service_name          = data.terraform_remote_state.fargate.outputs.service_name
  alb_listener_arn      = data.terraform_remote_state.fargate.outputs.alb_listener_arn
  alb_target_group_blue = data.terraform_remote_state.fargate.outputs.aws_lb_target_group_blue
  container_name        = data.terraform_remote_state.fargate.outputs.container_name
  container_port        = data.terraform_remote_state.fargate.outputs.container_port
}
