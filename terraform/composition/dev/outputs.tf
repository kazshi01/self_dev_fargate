output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.fargate.vpc_id
}

output "cluster_name" {
  description = "Name that identifies the cluster"
  value       = module.fargate.cluster_name
}

output "service_name" {
  description = "Name of the service"
  value       = module.fargate.service_name
}

output "https_listener_arns" {
  description = "The ARNs of the HTTPS load balancer listeners created."
  value       = module.fargate.https_listener_arns
}

output "target_group_names" {
  description = "Name of the target group. Useful for passing to your CodeDeploy Deployment Group."
  value       = module.fargate.target_group_names
}

output "service_task_definition_arn" {
  description = "Full ARN of the Task Definition (including both `family` and `revision`)"
  value       = module.fargate.service_task_definition_arn
}

output "container_name" {
  value = module.fargate.container_name
}

output "container_port" {
  value = module.fargate.container_port
}
