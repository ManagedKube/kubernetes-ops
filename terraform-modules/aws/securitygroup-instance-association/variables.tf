variable "instance_security_group_pairs" {
  description = <<EOT
  List of objects containing EC2 instance IDs and Security Group IDs to associate.
  Each object should have the following structure:
  {
    instance_id      = "i-0123456789abcdef0"
    security_group_id = "sg-0123456789abcdef0"
  }
  Example:
  [
    {
      instance_id      = "i-0123456789abcdef0"
      security_group_id = "sg-0123456789abcdef0"
    },
    {
      instance_id      = "i-0123456789abcdef1"
      security_group_id = "sg-0123456789abcdef1"
    }
  ]
  EOT
  type = list(object({
    instance_id      = string
    security_group_id = string
  }))
  default = []
}