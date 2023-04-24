variable "fetch_ec2_instance_name" {
  description = "The name of the EC2 instances to fetch"
  type        = string
  default     = ""
}

variable "fetch_ec2_instance_sg_id" {
  description = "The id of the SG to associate to EC2 instances to fetch"
  type        = string
  default     = ""
}

variable "fetch_ec2_instance_tag_name" {
  description = "The tag in order to filter of the EC2 instances to fetch"
  type        = string
  default     = ""
}

