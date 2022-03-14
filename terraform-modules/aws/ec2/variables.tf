variable "create_eni" {
  description = "Whether to create a secondary eni for the instance"
  type        = bool
  default     = false
}

variable "name" {
  description = "Name to be used on EC2 instance created"
  type        = string
  default     = ""
}

variable "ami" {
  description = "ID of AMI to use for the instance"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource"
  type        = string
  default     = null
}

variable "monitoring" {
  description = "If true, the launched EC2 instance will have detailed monitoring enabled"
  type        = bool
  default     = false
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with"
  type        = list(string)
  default     = null
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch in"
  type        = string
  default     = null
}

variable "private_ip" {
  description = "Private IP address to associate with the instance in a VPC"
  type        = string
  default     = null
}

variable "secondary_ips" {
  description = "Private IP address to associate with the optional second eni on the instance in a VPC"
  type        = list(string)
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with an instance in a VPC"
  type        = bool
  default     = null
}

variable "network_interface" {
  description = "Customize network interfaces to be attached at instance boot time"
  type        = list(map(string))
  default     = []
}

variable "source_dest_check" {
  description = "Controls if traffic is routed to the instance when the destination address does not match the instance. Used for NAT or VPNs."
  type        = bool
  default     = true
}

variable "root_block_device" {
  description = "Customize details about the root block device of the instance. See Block Devices below for details"
  type        = list(any)
  default     = []
}

variable "create_sg" {
  description = "Whether to create security group"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "ID of the VPC where to create security group"
  type        = string
  default     = null
}

variable "sg_name" {
  description = "Name of security group - not required if create_sg is false"
  type        = string
  default     = null
}

variable "sg_description" {
  description = "Description of security group"
  type        = string
  default     = "Security Group managed by Terraform"
}

variable "ingress_rules" {
  description = "List of ingress rules to create by name"
  type        = list(string)
  default     = []
}

variable "ingress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all ingress rules"
  type        = list(string)
  default     = []
}

variable "ingress_with_cidr_blocks" {
  description = "List of ingress rules to create where 'cidr_blocks' is used"
  type        = list(map(string))
  default     = []
}

variable "egress_rules" {
  description = "List of egress rules to create by name"
  type        = list(string)
  default     = []
}

variable "egress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all egress rules"
  type        = list(string)
  default     = []
}

variable "egress_with_cidr_blocks" {
  description = "List of egress rules to create where 'cidr_blocks' is used"
  type        = list(map(string))
  default     = []
}

variable "public_route_table_ids" {
  description = "Route table ID where the route will be created"
  type        = list(string)
  default     = []
}
variable "private_route_table_ids" {
  description = "Route table ID where the route will be created"
  type        = list(string)
  default     = []
}

variable "instance_id" {
  description = "Instance ID of the Jump host"
  type        = string
  default     = ""
}

variable "network_interface_id" {
  description = "Network interface ID of host for route"
  type        = string
  default     = ""
}

variable "instance_destination_cidr_blocks" {
  description = "List of destination cidr blocks for jump host"
  type        = list(string)
  default     = []
}
