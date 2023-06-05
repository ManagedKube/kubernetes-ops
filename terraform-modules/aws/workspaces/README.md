# AWS WORKSPACES

This Terraform configuration creates an AWS WORKSPACES architecture integrated with AD (Simple, Microsoft or Connector) also include a white list.

AWS WorkSpaces is a managed, secure Desktop-as-a-Service (DaaS) solution that helps you manage your desktop applications more easily. Here are a few reasons why it could be beneficial in the case of incompatibilities with your local machine:

    - Consistent Environment: AWS WorkSpaces allows you to standardize the environment for your applications, minimizing the differences between local environments that can lead to incompatibilities. It ensures that everyone on your team is using the same version of the operating system and applications, which helps reduce configuration and compatibility issues.

    - Scalability: WorkSpaces allows you to easily scale up or down depending on your needs. If you have new team members, you can quickly provision new WorkSpaces for them without worrying about hardware compatibility.ar

    - Security: WorkSpaces are stored in the AWS Cloud, and not on the local machine. This means that sensitive data isn't stored on potentially insecure local hardware. Moreover, AWS has robust security protocols in place to protect your data.

    - Flexibility: With AWS WorkSpaces, you can access your desktop anywhere, anytime, from any supported device. This allows employees to work with a familiar interface no matter where they are.

    - Cost-effective: Instead of investing in new hardware to solve compatibility issues, AWS WorkSpaces offers a pay-as-you-go model. This can save costs associated with hardware procurement, maintenance, and upgrades.

In summary, AWS WorkSpaces can provide a consistent, secure, and flexible working environment that can resolve many of the issues associated with local hardware and software incompatibilities.


# SUMMARY
To have a successful application, you must follow the order presented here:
1. WORKSPACES_IP_GROUP
2. WORKSPACES_DIRECTORY
3. WORKSPACES_WORKSPACES

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

