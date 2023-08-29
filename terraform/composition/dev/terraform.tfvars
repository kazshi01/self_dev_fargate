# ECR image
image_tag = "5"

# environment-layerと同じ値にする
northeast_domain = "marukome0909.com"
alb_domain       = "alb"
top_domain       = "cloudfront"

# Common
region      = "ap-northeast-1"
environment = "dev"
pet         = "marukome"

# VPC
vpc_cidr                     = "10.0.0.0/16"
create_database_subnet_group = false
enable_nat_gateway           = true
single_nat_gateway           = true

# Cluster

# Service
container_port = 80
deployment_controller = {
  type = "CODE_DEPLOY"
}

# ALB
load_balancer_type = "application"

# Route53
us_east_domain = "*.marukome0909.com"
