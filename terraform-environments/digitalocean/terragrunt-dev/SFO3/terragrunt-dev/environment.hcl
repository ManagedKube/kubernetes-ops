locals {
  project_name = "digitalocean-managekube"
  cluster_name = "digitalocean-terragrunt-dev"
  domain_name  = "digitalocean.managedkube.com"
  vpc = {
    availability_zones = []
    cidr               = ""
    private_subnets    = []
    public_subnets     = []
  }
}