output "vpc_id" {
  value = module.fargate.vpc_id
}

output "cluster_name" {
  value = module.fargate.cluster_name
}

output "service_name" {
  value = module.fargate.service_name
}

output "alb_listener_arn" {
  value = module.fargate.listener_arn
}

output "aws_lb_target_group_blue" {
  value = module.fargate.target_group_name
}

output "container_name" {
  value = module.fargate.container_name
}

output "container_port" {
  value = module.fargate.container_port
}
