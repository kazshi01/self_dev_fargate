###################################################
# compositionlayerの変数を変更する時はここも同じ値にする
###################################################
variable "northeast_domain" {
  type = string
  default = "marukome0909.com"
}

variable "alb_domain" {
  type = string
  default = "alb"
}

variable "top_domain" {
  type = string
  default = "cloudfront"
}

###############################
# VPC
###############################

variable "vpc_name" {
  type = string
  default = "terrafrom-vpc"
}

variable "vpc_cidr"{
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

variable "cluster_name" {
  type = string
  default     = "terrafrom-cluster"
}

###################################
# Service
###################################

variable "service_name" {
  type = string
  default     = "terrafrom-service"
}

variable "container_name" {
  type = string
  default = "terraform-container"
}

variable "container_port" {
  type = number
  default = 80
}

###################################
# ALB 
###################################

variable "alb_name" {
  type = string
  default     = "terrafrom-alb"
}

variable "load_balancer_type" {
  type = string
  default = "application"
}

###############################
# ROUTE53
###############################
variable "zone_name" {
  type =string
}

variable "zones" {
  type = any
}

variable "records" {
  type = any
}

###################################
# ACM
###################################

variable "zone_id" {
  type = string
}

variable "northeast_domain_name" {
  type = string
}

variable "us_east_domain_name" {
  type = string
}

###################################
# Cloudfront
###################################

variable "aliases" {
  type = any
}

variable "origin" {
  type = any
}

variable "default_cache_behavior" {
  type = any
}