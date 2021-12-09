## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_mongodbatlas"></a> [mongodbatlas](#requirement\_mongodbatlas) | 1.0.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_mongodbatlas"></a> [mongodbatlas](#provider\_mongodbatlas) | 1.0.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_vpc_endpoint.mongodbatlas](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [mongodbatlas_cluster.cluster](https://registry.terraform.io/providers/mongodb/mongodbatlas/1.0.1/docs/resources/cluster) | resource |
| [mongodbatlas_privatelink_endpoint.mongodbatlas](https://registry.terraform.io/providers/mongodb/mongodbatlas/1.0.1/docs/resources/privatelink_endpoint) | resource |
| [mongodbatlas_privatelink_endpoint_service.atlasplink](https://registry.terraform.io/providers/mongodb/mongodbatlas/1.0.1/docs/resources/privatelink_endpoint_service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_scaling_compute_enabled"></a> [auto\_scaling\_compute\_enabled](#input\_auto\_scaling\_compute\_enabled) | Specifies whether compute auto-scaling is enabled. The default is true. | `bool` | `false` | no |
| <a name="input_auto_scaling_compute_scale_down_enabled"></a> [auto\_scaling\_compute\_scale\_down\_enabled](#input\_auto\_scaling\_compute\_scale\_down\_enabled) | Set to true to enable the cluster tier to scale down. This option is only available if autoScaling.compute.enabled is true. | `bool` | `false` | no |
| <a name="input_auto_scaling_disk_gb_enabled"></a> [auto\_scaling\_disk\_gb\_enabled](#input\_auto\_scaling\_disk\_gb\_enabled) | Specifies whether disk auto-scaling is enabled. The default is true. | `bool` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region | `string` | n/a | yes |
| <a name="input_cloud_backup"></a> [cloud\_backup](#input\_cloud\_backup) | n/a | `bool` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster as it appears in Atlas. Once the cluster is created, its name cannot be changed. | `string` | n/a | yes |
| <a name="input_cluster_type"></a> [cluster\_type](#input\_cluster\_type) | Specifies the type of the cluster that you want to modify. You cannot convert a sharded cluster deployment to a replica set deployment. You should use cluster type When you set replication\_specs, when you are deploying Global Clusters or when you are deploying non-Global replica sets and sharded clusters. Accepted values include: REPLICASET Replica set, SHARDED Sharded cluster, GEOSHARDED Global Cluster | `string` | n/a | yes |
| <a name="input_disk_size_gb"></a> [disk\_size\_gb](#input\_disk\_size\_gb) | GCP/AWS Only) Capacity, in gigabytes, of the host’s root volume. Increase this number to add capacity, up to a maximum possible value of 4096 (i.e., 4 TB). This value must be a positive integer. The minimum disk size for dedicated clusters is 10GB for AWS and GCP. If you specify diskSizeGB with a lower disk size, Atlas defaults to the minimum disk size value. Note: The maximum value for disk storage cannot exceed 50 times the maximum RAM for the selected cluster. If you require additional storage space beyond this limitation, consider upgrading your cluster to a higher tier. Cannot be used with clusters with local NVMe SSDs | `number` | n/a | yes |
| <a name="input_egress_rule"></a> [egress\_rule](#input\_egress\_rule) | A list of ingress rules | `list(any)` | <pre>[<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "description": "All",<br>    "from_port": 0,<br>    "ipv6_cidr_blocks": [<br>      "::/0"<br>    ],<br>    "protocol": "-1",<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_electable_nodes"></a> [electable\_nodes](#input\_electable\_nodes) | Number of electable nodes for Atlas to deploy to the region. Electable nodes can become the primary and can facilitate local reads. The total number of electableNodes across all replication spec regions must total 3, 5, or 7. Specify 0 if you do not want any electable nodes in the region. You cannot create electable nodes in a region if priority is 0. | `number` | n/a | yes |
| <a name="input_iam_role_name"></a> [iam\_role\_name](#input\_iam\_role\_name) | The IAM Role name to assign an auth user to the DB | `string` | n/a | yes |
| <a name="input_ingress_rule"></a> [ingress\_rule](#input\_ingress\_rule) | A list of ingress rules | `list(any)` | <pre>[<br>  {<br>    "cidr_blocks": [<br>      "10.0.0.0/8",<br>      "172.16.0.0/12",<br>      "192.168.0.0/16",<br>      "100.64.0.0/16"<br>    ],<br>    "description": "All ports from internal addresses",<br>    "from_port": 0,<br>    "ipv6_cidr_blocks": [],<br>    "protocol": "tcp",<br>    "to_port": 65535<br>  }<br>]</pre> | no |
| <a name="input_javascript_enabled"></a> [javascript\_enabled](#input\_javascript\_enabled) | When true, the cluster allows execution of operations that perform server-side executions of JavaScript. When false, the cluster disables execution of those operations. | `bool` | n/a | yes |
| <a name="input_minimum_enabled_tls_protocol"></a> [minimum\_enabled\_tls\_protocol](#input\_minimum\_enabled\_tls\_protocol) | Sets the minimum Transport Layer Security (TLS) version the cluster accepts for incoming connections.Valid values are: TLS1\_0, TLS1\_1, TLS1\_2 | `string` | n/a | yes |
| <a name="input_mongo_db_major_version"></a> [mongo\_db\_major\_version](#input\_mongo\_db\_major\_version) | Version of the cluster to deploy. Atlas supports the following MongoDB versions for M10+ clusters: 3.6, 4.0, or 4.2. You must set this value to 4.2 if provider\_instance\_size\_name is either M2 or M5. | `string` | `"5.0"` | no |
| <a name="input_mongodbatlas_projectid"></a> [mongodbatlas\_projectid](#input\_mongodbatlas\_projectid) | The unique ID for the project to create the database user. | `string` | n/a | yes |
| <a name="input_num_shards"></a> [num\_shards](#input\_num\_shards) | Selects whether the cluster is a replica set or a sharded cluster. If you use the replicationSpecs parameter, you must set num\_shards. | `string` | n/a | yes |
| <a name="input_priority"></a> [priority](#input\_priority) | Election priority of the region. For regions with only read-only nodes, set this value to 0. For regions where electable\_nodes is at least 1, each region must have a priority of exactly one (1) less than the previous region. The first region must have a priority of 7. The lowest possible priority is 1. The priority 7 region identifies the Preferred Region of the cluster. Atlas places the primary node in the Preferred Region. Priorities 1 through 7 are exclusive - no more than one region per cluster can be assigned a given priority. Example: If you have three regions, their priorities would be 7, 6, and 5 respectively. If you added two more regions for supporting electable nodes, the priorities of those regions would be 4 and 3 respectively. | `number` | n/a | yes |
| <a name="input_provider_auto_scaling_compute_max_instance_size"></a> [provider\_auto\_scaling\_compute\_max\_instance\_size](#input\_provider\_auto\_scaling\_compute\_max\_instance\_size) | The maximum instance size when scaling up | `string` | `null` | no |
| <a name="input_provider_auto_scaling_compute_min_instance_size"></a> [provider\_auto\_scaling\_compute\_min\_instance\_size](#input\_provider\_auto\_scaling\_compute\_min\_instance\_size) | The minimum instance size when scaling down | `string` | `null` | no |
| <a name="input_provider_instance_size_name"></a> [provider\_instance\_size\_name](#input\_provider\_instance\_size\_name) | Atlas provides different instance sizes, each with a default storage capacity and RAM size. The instance size you select is used for all the data-bearing servers in your cluster. See Create a Cluster providerSettings.instanceSizeName for valid values and default resources. Note free tier (M0) creation is not supported by the Atlas API and hence not supported by this provider.) | `string` | n/a | yes |
| <a name="input_provider_name"></a> [provider\_name](#input\_provider\_name) | Cloud service provider on which the servers are provisioned. The possible values are: AWS - Amazon AWS, GCP - Google Cloud Platform, AZURE - Microsoft Azure, TENANT - A multi-tenant deployment on one of the supported cloud service providers. Only valid when providerSettings.instanceSizeName is either M2 or M5. | `string` | n/a | yes |
| <a name="input_read_only_nodes"></a> [read\_only\_nodes](#input\_read\_only\_nodes) | Number of read-only nodes for Atlas to deploy to the region. Read-only nodes can never become the primary, but can facilitate local-reads. Specify 0 if you do not want any read-only nodes in the region. | `number` | n/a | yes |
| <a name="input_region_name"></a> [region\_name](#input\_region\_name) | n/a | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Set of EC2 Subnet IDs. | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A list of Tags | `map(any)` | n/a | yes |
| <a name="input_user_password"></a> [user\_password](#input\_user\_password) | The default password for all Aric MongoDB users. | `string` | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC id | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_endpoint_service_name"></a> [endpoint\_service\_name](#output\_endpoint\_service\_name) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
| <a name="output_private_link_id"></a> [private\_link\_id](#output\_private\_link\_id) | n/a |
| <a name="output_service_endpoint_dns"></a> [service\_endpoint\_dns](#output\_service\_endpoint\_dns) | n/a |
| <a name="output_status"></a> [status](#output\_status) | n/a |
