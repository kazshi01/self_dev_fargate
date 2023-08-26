##################################################################
# Application Load Balancer
##################################################################

module "alb" {
  source = "../../../modules/alb"

  name = var.alb_name

  load_balancer_type = var.load_balancer_type

  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets
  # Attach security groups
  security_groups = [module.vpc.default_security_group_id]
  # Attach rules to the created security group
  security_group_rules = {
    ingress_all_http = {
      type        = "ingress"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "HTTP web traffic"
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress_all_https = {
      type        = "ingress"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "HTTPS web traffic"
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress_all = {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # # See notes in README (ref: https://github.com/terraform-providers/terraform-provider-aws/issues/7987)
  # access_logs = {
  #   bucket = module.log_bucket.s3_bucket_id
  # }

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
      action_type        = "forward"
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = module.acm.acm_certificate_arn
      target_group_index = 0
    }
  ]

  target_groups = [
    {
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "ip"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
      }
    }
  ]
}

###############################
# ROUTE53
###############################

module "disabled_records" {
  source = "../../../modules/route53/records"

  create = false
}

module "zones" {
  source = "../../../modules/route53/zones"

  zones = {
    "${var.northeast_domain}" = {
      comment = "${var.northeast_domain} (production)"
      tags = {
        Name = var.northeast_domain
      }
    }
  }
}

module "records" {
  source = "../../../modules/route53/records"

  zone_name = var.zone_name

  records = [
    {
      name = var.alb_domain
      type = "A"
      alias = {
        name                   = module.alb.lb_dns_name
        zone_id                = module.alb.lb_zone_id
        evaluate_target_health = true
      }
    },


    {
      name = var.top_domain
      type = "A"
      alias = {
        name    = module.cloudfront.cloudfront_distribution_domain_name
        zone_id = module.cloudfront.cloudfront_distribution_hosted_zone_id
      }
    }
  ]

  depends_on = [module.zones]
}

###############################
# ACM
###############################

module "acm" {
  source = "../../../modules/acm"

  domain_name = var.northeast_domain_name
  zone_id     = var.zone_id

}

module "acm_us_east" {
  source = "../../../modules/acm"

  providers = {
    aws = aws.us_east
  }

  domain_name = var.us_east_domain_name
  zone_id     = var.zone_id

}

###############################
# CLOUDFRONT
###############################

module "cloudfront" {
  source = "../../../modules/cloudfront"

  aliases = var.aliases

  comment             = "My awesome CloudFront"
  enabled             = true
  http_version        = "http2and3"
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  wait_for_deployment = false

  origin = var.origin

  default_cache_behavior = var.default_cache_behavior

  viewer_certificate = {
    acm_certificate_arn = module.acm_us_east.acm_certificate_arn
    ssl_support_method  = "sni-only"
  }

  depends_on = [module.acm]
}