variable "aws_region" {
    default = "us-east-1"
}
variable "tags" {}
variable "vpc_id" {
    default = ""
}
variable "private_subnets" {
    type = list
    default = []
}
variable "public_subnets" {
    type = list
    default = []
}
variable "cluster_name" {
    default = "test-cluster
}