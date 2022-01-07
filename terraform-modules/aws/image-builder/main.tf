provider "aws" {
  region = var.aws_region
}

resource "aws_iam_instance_profile" "InstanceProfileForImageBuilder" {
  name = "${var.custom_prefix}${var.aws_iam_instance_profile_name}"
  role = aws_iam_role.role.name
  tags = var.tags
}

resource "aws_iam_role" "role" {
  name               = "${var.custom_prefix}${var.aws_iam_role_name}"
  path               = "/"
  tags               = var.tags
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilder"
}

resource "aws_iam_role_policy_attachment" "attach1" {
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilderECRContainerBuilds"
}

resource "aws_iam_role_policy_attachment" "attach2" {
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_imagebuilder_image_recipe" "builder" {
  name         = "${var.custom_prefix}${var.recipe_name}"
  parent_image = "arn:aws:imagebuilder:${var.aws_region}:aws:image/${var.recipe_parent_image}/x.x.x"
  version      = var.recipe_version
  tags         = var.tags

  component {
    component_arn = aws_imagebuilder_component.component.arn
  }

  description       = "A document that defines the source image and the components that are applied to the source image to produce the desired configuration for the output AMI image."
  working_directory = var.recipe_working_directory
  block_device_mapping {
    device_name = var.recipe_device_name

    ebs {
      delete_on_termination = var.recipe_ebs_delete_on_termination
      volume_size           = var.recipe_ebs_volume_size
      volume_type           = var.recipe_ebs_volume_type
      encrypted             = var.recipe_ebs_volume_encrypted
    }
  }
}

resource "aws_imagebuilder_image_pipeline" "builder" {
  description                      = "Defines the build, validation, and test phases for an image build lifecycle."
  image_recipe_arn                 = aws_imagebuilder_image_recipe.builder.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.builder.arn
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.builder.arn
  name                             = "${var.custom_prefix}${var.pipeline_name}"
  enhanced_image_metadata_enabled  = var.pipeline_enhanced_image_metadata_enabled
  tags                             = var.tags
}

resource "aws_imagebuilder_infrastructure_configuration" "builder" {
  instance_profile_name         = aws_iam_instance_profile.InstanceProfileForImageBuilder.name
  description                   = "Specifies infrastructure details for the instances that will run in your AWS account during the build process."
  name                          = "${var.custom_prefix}${var.infrastructure_configuration_name}"
  instance_types                = var.infastructure_configuration_instance_types
  terminate_instance_on_failure = false
  tags                          = var.tags
  #For VPC
  security_group_ids = var.infrastructure_configuration_security_group_ids
  subnet_id          = var.infrastructure_configuration_subnet_id

}

resource "aws_imagebuilder_component" "component" {
  name        = "${var.custom_prefix}${var.component_name}"
  description = "Defines the sequence of steps required to either customize an instance prior to image creation (a build component), or to test an instance that was launched from the created image (a test component)."
  platform    = "Linux"
  version     = var.component_version
  tags        = var.tags
  data        = var.component_data
}

resource "aws_imagebuilder_distribution_configuration" "builder" {
  name        = "${var.custom_prefix}${var.distribution_configuration_name}"
  description = "AMI distribution settings for your image after the build is complete and has passed all its tests."
  tags        = var.tags
  distribution {
    region = var.aws_region
    ami_distribution_configuration {
      name        = "${var.custom_prefix}${var.recipe_parent_image}-{{ imagebuilder:buildDate }}"
      ami_tags    = var.tags
      description = "A custom ${var.custom_prefix}${var.recipe_parent_image} image"
    }
  }
}
