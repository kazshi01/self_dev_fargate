###################################
# environment-layerと同じ値にする
###################################

variable "northeast_domain" {
  type = string
}

variable "alb_domain" {
  type = string
}

variable "top_domain" {
  type = string
}

###################################
# Common
###################################

variable "region" {
  description = "The AWS region"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "pet" {
  type = string
}

###################################
# VPC
###################################

variable "vpc_cidr" {
  type = string
}

variable "create_database_subnet_group" {
  description = "Controls if database subnet group should be created (n.b. database_subnets must also be set)"
  type        = bool
  default     = true
}

variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = false
}

###################################
# Cluster
###################################



###################################
# Service
###################################

variable "container_port" {
  type    = number
  default = 80
}

variable "image" {
  description = "The image to use"
  type        = string
  default     = "my-default-image"
}

variable "image_tag" {
  description = "The tag for the ECR image"
  type        = string
}

###################################
# ALB
###################################

variable "load_balancer_type" {
  type    = string
  default = "application"
}

###################################
# Route53
###################################

variable "us_east_domain" {
  type = string
}
