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

  subnet_id         = var.subnet_id
  private_ips       = var.secondary_ips
  security_groups   = [module.aws_security_group.security_group_id]
  source_dest_check = var.source_dest_check

  tags = var.tags

  attachment {
    instance     = module.aws_instance.id
    device_index = 1
  }
}

module "aws_security_group" {
  source = "terraform-aws-modules/security-group/aws"
  version = "v4.9.0"

  create_sg   = var.create_sg
  name        = var.sg_name
  description = var.sg_description
  vpc_id      = var.vpc_id

  ingress_cidr_blocks      = var.ingress_cidr_blocks
  ingress_rules            = var.ingress_rules
  ingress_with_cidr_blocks = var.ingress_with_cidr_blocks

  egress_cidr_blocks      = var.egress_cidr_blocks
  egress_rules            = var.egress_rules
  egress_with_cidr_blocks = var.egress_with_cidr_blocks
}

resource "aws_route" "private_instance_route" {
  count                  = length(var.instance_destination_cidr_blocks)
  route_table_id         = var.private_route_table_ids[0]
  destination_cidr_block = element(var.instance_destination_cidr_blocks, count.index)
  network_interface_id   = aws_network_interface.this[0].id
}

resource "aws_route" "public_instance_route" {
  count                  = length(var.instance_destination_cidr_blocks)
  route_table_id         = var.public_route_table_ids[0]
  destination_cidr_block = element(var.instance_destination_cidr_blocks, count.index)
  network_interface_id   = aws_network_interface.this[0].id
}
