data "aws_availability_zones" "available" {}

locals {

  ##VPC
  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  ##ECS
  container_name = "marukome-container"
  container_port = 80

  ##ROTE53
  zone_name = sort(keys(module.zones.route53_zone_zone_id))[0]
  zone_id   = module.zones.route53_zone_zone_id["${local.domain}"]

  ##ACM
  # Use existing (via data source) or create new zone (will fail validation, if zone is not reachable)
  domain = "marukome0909.com"
  acm_domain = "*.marukome0909.com"

  # Removing trailing dot from domain - just to be sure :)
  domain_name      = trimsuffix(local.domain, ".")
  acm_domain_name  = trimsuffix(local.acm_domain, ".")
  alb_domain        = "alb"
  top_domain = "top"
}