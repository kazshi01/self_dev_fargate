module "fargate" {
  source = "../../environment/dev/fargate"

  ## VPC 
  vpc_name = "${var.environment}-${var.pet}-vpc"
  vpc_cidr = var.vpc_cidr

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway

  create_database_subnet_group = var.create_database_subnet_group

  ## Cluster
  cluster_name = "${var.environment}-${var.pet}-cluster"

  ## Service
  service_name          = "${var.environment}-${var.pet}-service"
  container_name        = "${var.environment}-${var.pet}-container"
  container_port        = var.container_port
  deployment_controller = var.deployment_controller
  image                 = local.image

  ## ALB
  alb_name           = "${var.environment}-${var.pet}-alb"
  load_balancer_type = var.load_balancer_type

  ## Route53
  zones = local.zones

  zone_name = local.zone_name
  records   = local.records

  ## ACM
  northeast_domain_name = "${var.alb_domain}.${local.northeast_domain_name}"
  us_east_domain_name   = local.us_east_domain_name
  zone_id               = local.zone_id

  ## Cloudfront
  aliases                = ["${var.top_domain}.${local.northeast_domain_name}"]
  origin                 = local.origin
  default_cache_behavior = local.default_cache_behavior
}
