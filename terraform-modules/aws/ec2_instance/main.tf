locals {
  sudoers                     = base64gzip(file("${path.module}/files/99-custom-sudoers"))
  fsinstaller_ssh_private_key = var.fsinstaller_ssh_private_key
  fsinstaller_ssh_public_key  = var.fsinstaller_ssh_public_key

  # combine user's IAM policy arn list with what is created in this module
  complete_aws_iam_role_policy_attachment_list = concat(var.aws_iam_role_policy_attachment_list, 
    [
      "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM", 
      aws_iam_policy.datadog.arn,
      aws_iam_policy.node_configs.arn,
    ])
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  name           = var.instance_name
  instance_count = 1

  ami           = var.ami
  instance_type = var.instance_config.root_installer_device.instance_type
  key_name      = var.key_pair_name != null ? var.key_pair_name: aws_key_pair.this[0].id
  monitoring    = true
  vpc_security_group_ids = var.security_group_list
  subnet_id = var.subnet_id

  # instance profile created in this module for each individual node
  iam_instance_profile = aws_iam_instance_profile.instance_profile.id

  tags = var.tags

  enable_volume_tags = true
  root_block_device = [
    {
      delete_on_termination = var.instance_config.root_installer_device.delete_on_termination
      encrypted             = var.instance_config.root_installer_device.encrypted
      iops                  = var.instance_config.root_installer_device.volume_type == "io2" ? var.instance_config.root_installer_device.iops : null
      kms_key_id            = var.instance_config.root_installer_device.kms_key_id
      volume_size           = var.instance_config.root_installer_device.volume_size
      volume_type           = var.instance_config.root_installer_device.volume_type
    },
  ]

  ebs_block_device = var.instance_config.ebs_block_device

  user_data = templatefile("${path.module}/cloud-init/user-data.yaml.tpl", {
          sudoers                         = local.sudoers
          aric_user_ssh_public_key             = var.aric_user_ssh_public_key
          ebs_block_device_1_is_set       = var.instance_config.user_data_inputs.ebs_block_device_1_is_set
          ebs_block_device_1_mount_path   = var.instance_config.user_data_inputs.ebs_block_device_1_mount_path
          ebs_block_device_2_is_set       = var.instance_config.user_data_inputs.ebs_block_device_2_is_set
          ebs_block_device_2_mount_path   = var.instance_config.user_data_inputs.ebs_block_device_2_mount_path
          fsinstaller_ssh_private_key     = var.fsinstaller_ssh_private_key
          fsinstaller_ssh_public_key      = var.fsinstaller_ssh_public_key
        })

  depends_on = [
    aws_iam_instance_profile.instance_profile,
  ]
}

resource "aws_key_pair" "this" {
  count = var.key_pair_name == null ? 1: 0
  key_name   = var.instance_name
  public_key = var.aric_user_ssh_public_key
}

# Instance profile
resource "aws_iam_instance_profile" "instance_profile" {
  name  = var.instance_name
  role  = aws_iam_role.instance_role.name
}

# Instance role
resource "aws_iam_role" "instance_role" {

  name = var.instance_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  description = "A role for the ${var.instance_name} node"
}

# Attached the list of policies to the instance profile
resource "aws_iam_role_policy_attachment" "attach_policies" {
  count      = length(concat(local.complete_aws_iam_role_policy_attachment_list))
  role       = aws_iam_role.instance_role.name
  policy_arn = local.complete_aws_iam_role_policy_attachment_list[count.index]
}

# # Policy for datadog - allows the node to get AWS metrics
# # Datadog doc: https://docs.datadoghq.com/integrations/amazon_ec2/#configuration
resource "aws_iam_policy" "datadog" {
  name   = "${var.instance_name}-datadog"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["ec2:DescribeInstanceStatus", "ec2:DescribeSecurityGroups", "ec2:DescribeInstances"]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })

  tags = var.tags
}

# Policy for S3 Bucket - allows the node to get read-only access to s3 buckets for the node_config items
# For the "all" nodes
resource "aws_iam_policy" "node_configs" {
  name  = "${var.instance_name}-node-configs"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : ["s3:GetObject", "s3:ListBucket"],
        "Effect" : "Allow",
        "Resource" : "arn:aws:s3:::${var.environment_name}-installer/node_configs/*"
      }
    ]
  })
}
