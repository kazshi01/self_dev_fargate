##################################################################
# Application Load Balancer
##################################################################

module "alb" {
  source = "../../../modules/alb"

  name = "${var.environment}-marukome-alb"

  load_balancer_type = "application"

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
    "${local.domain}" = {
      comment = "${local.domain} (production)"
      tags = {
        Name = local.domain
      }
    }
  }
}

module "records" {
  source = "../../../modules/route53/records"

  zone_name = local.zone_name

  records = [
    {
      name = local.alb_domain
      type = "A"
      alias = {
        name                   = module.alb.lb_dns_name
        zone_id                = module.alb.lb_zone_id
        evaluate_target_health = true
      }
    },


    {
      name = local.top_domain
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

  domain_name = "${local.alb_domain}.${local.domain_name}"
  zone_id     = local.zone_id

  tags = {
    Name = "${local.alb_domain}.${local.domain_name}"
  }
}

module "acm_us_east" {
  source = "../../../modules/acm"

  providers = {
    aws = aws.us_east
  }

  domain_name = local.acm_domain_name
  zone_id     = local.zone_id

  tags = {
    Name = "${local.top_domain}.${local.domain_name}"
  }
}

###############################
# CLOUDFRONT
###############################

module "cloudfront" {
  source = "../../../modules/cloudfront"

  aliases = ["${local.top_domain}.${local.domain_name}"]

  comment             = "My awesome CloudFront"
  enabled             = true
  http_version        = "http2and3"
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  wait_for_deployment = false

  origin = {
    "${local.alb_domain}" = {
      domain_name = "${local.alb_domain}.${local.domain_name}"
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "https-only"
        origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
      }

      custom_header = [
        {
          name  = "X-Forwarded-Scheme"
          value = "https"
        },
        {
          name  = "X-Frame-Options"
          value = "SAMEORIGIN"
        }
      ]
    }
  }

  default_cache_behavior = {
    target_origin_id       = "${local.alb_domain}"
    viewer_protocol_policy = "https-only"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    query_string           = true

    # This is id for SecurityHeadersPolicy copied from https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-response-headers-policies.html
    response_headers_policy_id = "67f7725c-6f97-4210-82d7-5512b31e9d03"
  }

  viewer_certificate = {
    acm_certificate_arn = module.acm_us_east.acm_certificate_arn
    ssl_support_method  = "sni-only"
  }

  depends_on = [module.acm]
}