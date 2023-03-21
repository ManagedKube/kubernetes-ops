 Terraform module for setting up an AWS OpenSearch domain, This module supports both public and VPC-based deployments, depending on the value of the `vpc_enabled` variable. The module covers the creation of an OpenSearch domain, security group, and associated ingress and egress rules.

**Key Features**

- OpenSearch domain creation with `aws_opensearch_domain` resource.
- Security group creation with `aws_security_group` resource, including ingress and egress rules.
- Ingress and egress rules support for CIDR blocks and IPv6 CIDR blocks.
- Cloudwatch Log groups - To publish slow logs to CloudWatch Log Groups for monitoring and analysis

**Input Variables**

- domain_name (Optional, string): The user-friendly name for the OpenSearch domain. If not provided, Terraform will generate a default domain name.
- aws_region (Optional, string, default: "us-west-2"): The AWS region where the OpenSearch domain will be created.
- account_id (Optional, string): The AWS account ID of your AWS account.
- tags (Optional, any, default: {}): AWS tags that will be applied to the OpenSearch domain and related resources.
- subnet_ids (Required, list(string)): A list of private subnet IDs within your VPC where the OpenSearch domain will be created.
- vpc_id (Required, string): The ID of the VPC where the OpenSearch domain will be created.
- instance_count (Optional, number, default: 2): The number of instances in the OpenSearch domain cluster.
- ingress_rule (Optional, list(any), default: provided): A list of ingress rules for the OpenSearch domain security group.
- egress_rule (Optional, list(any), default: provided): A list of egress rules for the OpenSearch domain security group.

**Domain Configuration**
The OpenSearch domain is created using the aws_opensearch_domain resource with the following settings:

- Engine version: OpenSearch 2.5
- Cluster instance type: r4.large.search
- Zone awareness enabled : By Default 2 availability zones
- EBS storage enabled with 10GB volume size
- [Encryption at rest](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearch_domain#encrypt_at_rest) and [node-to-node encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearch_domain#node_to_node_encryption) enabled
- HTTPS enforced with TLS security policy: [Policy-Min-TLS-1-2-2019-07](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearch_domain#tls_security_policy)

- vpc_options: A dynamic block that conditionally creates a VPC configuration for the domain, based on the value of vpc_enabled.
- access_policies: JSON-encoded access policies for the domain, with a conditional policy that enforces secure transport (HTTPS) if the domain is deployed within a VPC.
- Log publishing options for index slow logs, search slow logs.

**Security Group Configuration**
- The security group is created using the aws_security_group resource, and it includes ingress and egress rules for controlling access to the OpenSearch domain.

  - The ingress rules are defined in the ingress_rule variable.
  - The egress rules are defined in the egress_rule variable.

Both ingress and egress rules support CIDR blocks and IPv6 CIDR blocks.