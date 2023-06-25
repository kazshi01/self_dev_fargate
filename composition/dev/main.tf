###################################
# VPC 
###################################
module "fargate" {
  source = "../../environment/dev/fargate"

  name = "${var.pet}-vpc"
  vpc_cidr = var.vpc_cidr

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway

  create_database_subnet_group  = var.create_database_subnet_group

}