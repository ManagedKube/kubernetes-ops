output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_name" {
  description = "name of vpc"
  value       = module.vpc.name
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = var.vpc_cidr
}

output "private_subnets" {
  description = "A list of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "A list of public subnets"
  value       = module.vpc.public_subnets
}

output "k8s_subnets" {
  description = "A list of private k8s subnets"
  value       = module.vpc.elasticache_subnets
}

output "private_route_table_ids" {
  description = "A list of route table ids for private subnets"
  value       = module.vpc.private_route_table_ids
}

output "public_route_table_ids" {
  description = "A list of route table ids for public subnets"
  value       = module.vpc.public_route_table_ids
}

output "vpc_secondary_cidr_blocks" {
  description = "List of secondary CIDR blocks of the VPC"
  value       = module.vpc.vpc_secondary_cidr_blocks
}
