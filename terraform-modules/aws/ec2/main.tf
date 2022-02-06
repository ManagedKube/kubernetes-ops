module "aws_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "v3.4.0"

  name                   = var.name
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  monitoring             = var.monitoring
#   vpc_security_group_ids = var.vpc_security_group_ids
  subnet_id              = var.subnet_id
  private_ip             = var.private_ip
#   network_interface      = var.network_interface
  source_dest_check      = var.source_dest_check
  root_block_device      = var.root_block_device

  associate_public_ip_address = var.associate_public_ip_address

  tags = var.tags
}

resource "aws_network_interface" "this" {
  count = var.create_eni ? 1 : 0

  subnet_id       = var.subnet_id
  private_ips     = var.secondary_ips
  security_groups = var.vpc_security_group_ids
  source_dest_check      = var.source_dest_check

  tags = var.tags

  attachment {
    instance     = module.aws_instance.id
    device_index = 1
  }
}