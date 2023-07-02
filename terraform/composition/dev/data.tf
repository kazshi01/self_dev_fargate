data "aws_ecr_repository" "existing_repo" {
  name = "dev/practice"
}

locals {

  image = "${data.aws_ecr_repository.existing_repo.repository_url}:${var.image_tag}"

  zones = {
    "${var.northeast_domain}" = {
      comment = "${var.northeast_domain} (production)"
      tags = {
        Name = var.northeast_domain
      }
    }
  }

  records = [
    {
      name = var.alb_domain
      type = "A"
      alias = {
        name                   = module.fargate.lb_dns_name
        zone_id                = module.fargate.lb_zone_id
        evaluate_target_health = true
      }
    },
    {
      name = var.top_domain
      type = "A"
      alias = {
        name    = module.fargate.cloudfront_distribution_domain_name
        zone_id = module.fargate.cloudfront_distribution_hosted_zone_id
      }
    }
  ]

  ##ROUTE53
  zone_name = sort(keys(module.fargate.route53_zone_zone_id))[0]
  zone_id   = module.fargate.route53_zone_zone_id["${var.northeast_domain}"]

  ##ACM
  # Removing trailing dot from domain - just to be sure :)
  northeast_domain_name      = trimsuffix(var.northeast_domain, ".")
  us_east_domain_name  = trimsuffix(var.us_east_domain, ".")

  ##Cloudfront
  origin = {
    "${var.alb_domain}" = {
      domain_name = "${var.alb_domain}.${local.northeast_domain_name}"
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
    target_origin_id       = "${var.alb_domain}"
    viewer_protocol_policy = "https-only"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    query_string           = true

    # This is id for SecurityHeadersPolicy copied from https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-response-headers-policies.html
    response_headers_policy_id = "67f7725c-6f97-4210-82d7-5512b31e9d03"
  }
}
