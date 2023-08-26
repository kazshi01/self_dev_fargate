################################################################################
# VPC Module
################################################################################

module "vpc" {
  source = "../../../modules/vpc"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs              = local.azs
  private_subnets  = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k)]
  public_subnets   = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 4)]
  database_subnets = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 8)]

  private_subnet_names = ["Private Subnet A", "Private Subnet C", "Private Subnet D"]

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway

  manage_default_security_group = false
  create_database_subnet_group  = var.create_database_subnet_group

}

###########################
# Security groups examples
###########################
# module "compute_sg" {
#   source = "../../../modules/security_group"

#   name        = "compute-sg"
#   description = "Security group which is used as an argument in complete-sg"
#   vpc_id      = module.vpc.vpc_id

#   ingress_cidr_blocks = ["0.0.0.0/0"]
#   ingress_rules       = ["http-80-tcp"]
#   egress_rules        = ["all-all"]
# }

module "mysql_sg" {
  source = "../../../modules/security_group"

  name        = "mysql-sg"
  description = "Security group with MySQL/Aurora port open for HTTP security group created above (computed)"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules        = ["all-all"]

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = module.ecs_service.security_group_id
    },
  ]

  number_of_computed_ingress_with_source_security_group_id = 1
}
