output "global_network_id" {
    description = "The ID of the Global Network"
    value = module.cloudwan.global_network.id
  
}

output "core_network_id" {
    description = "The ID of the Global Network"
    value = module.cloudwan.core_network.id
  
}