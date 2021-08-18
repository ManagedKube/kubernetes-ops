output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
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
  description = "A list of k8s subnets"
  value       = module.vpc.k8s_subnets
}
