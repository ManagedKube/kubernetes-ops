## Description
This Terraform code performs the following actions:

- Fetches all EC2 instances with a specific tag name and value using the aws_instances 
  data source. The tag name is provided through the variable fetch_ec2_instance_tag_name 
  and the tag value through the variable fetch_ec2_instance_name.

- Outputs the list of instance IDs fetched in the previous step using the instance_ids 
  output variable. The tolist function is used to convert the instance IDs into a list.

- Creates an aws_network_interface_sg_attachment resource for each instance in the list 
  of instance_ids. This resource associates an additional security group to the primary 
  network interface of each fetched EC2 instance. The security group ID to be associated 
  is provided through the variable fetch_ec2_instance_sg_id.

In summary, this Terraform code locates EC2 instances based on a specific tag, retrieves their 
instance IDs, and associates an additional security group to the primary network interface of 
each found instance.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_network_interface_sg_attachment.extra_sg_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface_sg_attachment) | resource |
| [aws_instances.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/instances) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_fetch_ec2_instance_name"></a> [fetch\_ec2\_instance\_name](#input\_fetch\_ec2\_instance\_name) | The name of the EC2 instances to fetch | `string` | `""` | no |
| <a name="input_fetch_ec2_instance_sg_id"></a> [fetch\_ec2\_instance\_sg\_id](#input\_fetch\_ec2\_instance\_sg\_id) | The id of the SG to associate to EC2 instances to fetch | `string` | `""` | no |
| <a name="input_fetch_ec2_instance_tag_name"></a> [fetch\_ec2\_instance\_tag\_name](#input\_fetch\_ec2\_instance\_tag\_name) | The tag in order to filter of the EC2 instances to fetch | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_ids"></a> [instance\_ids](#output\_instance\_ids) | n/a |
