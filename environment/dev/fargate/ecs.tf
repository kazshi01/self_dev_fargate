################################################################################
# Cluster
################################################################################

module "ecs_cluster" {
  source = "../../../modules/ecs/cluster"

  cluster_name = var.cluster_name

  # Capacity provider
  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 50
        base   = 20
      }
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
  }
}

################################################################################
# Service
################################################################################

module "ecs_service" {
  source = "../../../modules/ecs/service"

  name        = var.service_name
  cluster_arn = module.ecs_cluster.arn

  cpu    = 1024
  memory = 4096

  # Container definition(s)
  container_definitions = {

    (var.container_name) = {
      cpu       = 512
      memory    = 1024
      essential = true
      image     = "nginx:latest" ###のちにECRイメージを指定
      port_mappings = [
        {
          name          = var.container_name
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]

      # Example image used requires access to write to root filesystem
      readonly_root_filesystem = false

      enable_cloudwatch_logging = false

      memory_reservation = 100
    }
  }

  load_balancer = {
    service = {
      target_group_arn = element(module.alb.target_group_arns, 0)
      container_name   = var.container_name
      container_port   = var.container_port
    }
  }

  subnet_ids = module.vpc.private_subnets
  security_group_rules = {
    alb_ingress = {
      type                     = "ingress"
      from_port                = var.container_port
      to_port                  = var.container_port
      protocol                 = "tcp"
      description              = "Service port"
      source_security_group_id = module.alb.security_group_id
    }
    egress_all = {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}