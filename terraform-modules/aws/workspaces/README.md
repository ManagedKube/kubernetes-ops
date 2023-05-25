# AWS WORKSPACES

This Terraform configuration creates an AWS WORKSPACES architecture integrated with AD (Simple, Microsoft or Connector) also include a white list

# Summary

## WORKSPACES_IP_GROUP
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/workspaces_ip_group 
The configuration creates the following resources:

    An AWS Workspaces IP group
    A list of IP group rules

### Important Things to Consider

    The account_name variable must be set to the name of the AWS account that will be used to create the IP group.
    The ip_group_rules variable must be set to a list of IP group rules. Each rule must specify the source IP address and a description.
    The tags variable can be used to add tags to the AWS resources created by this Terraform configuration.

## WORKSPACES_DIRECTORY
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/workspaces_directory
The configuration creates the following resources:

    An AWS Directory Service directory
    An AWS Workspaces directory

### Is It Possible Connect with Okta Integration
yes, you need to use MicrosoftAD type and install okta agent in a ec2 joined to domain.
Docs:
https://help.okta.com/en-us/Content/Topics/Directory/ad-agent-new-integration.htm 

### Important Things to Consider

    The account_name variable must be set to the name of the AWS account that will be used to create the resources.
    The directory_service_directory_name variable must be set to the name of the AWS Directory Service directory that will be used to create the AWS Workspaces directory.
    The workspaces_directory_name variable must be set to the name of the AWS Workspaces directory that will be created.
    The ip_group_rules variable must be set to a list of IP group rules. Each rule must specify the source IP address and a description.
    The self_service_permissions variable must be set to a set of permissions for users. The permissions can be used to control what users can do with their AWS Workspaces.

## WORKSPACES_WORKSPACES
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/workspaces_workspace 

The code creates a list of AWS Workspaces. Each workspace is configured with a user name, compute type, user volume size, root volume size, running mode, and running mode auto-stop timeout in minutes. The code then creates the workspaces and outputs their IDs, IP addresses, computer names, states, and tags.

