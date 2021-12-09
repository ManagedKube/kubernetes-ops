variable "aws_region" {
  type        = string
  description = "The AWS region"
}

variable "mongodbatlas_projectid" {
  type        = string
  description = "The unique ID for the project to create the database user."
}

variable "cluster_name" {
  type        = string
  description = "Name of the cluster as it appears in Atlas. Once the cluster is created, its name cannot be changed."
}

variable "cluster_type" {
  type        = string
  description = "Specifies the type of the cluster that you want to modify. You cannot convert a sharded cluster deployment to a replica set deployment. You should use cluster type When you set replication_specs, when you are deploying Global Clusters or when you are deploying non-Global replica sets and sharded clusters. Accepted values include: REPLICASET Replica set, SHARDED Sharded cluster, GEOSHARDED Global Cluster"
}

variable "num_shards" {
  type        = string
  description = "Selects whether the cluster is a replica set or a sharded cluster. If you use the replicationSpecs parameter, you must set num_shards."
}

variable "region_name" {
  type        = string
  description = ""
}

variable "cloud_backup" {
  type        = bool
  description = ""
}

variable "auto_scaling_disk_gb_enabled" {
  type        = bool
  description = "Specifies whether disk auto-scaling is enabled. The default is true."
}

variable "auto_scaling_compute_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether compute auto-scaling is enabled. The default is true."
}

variable "auto_scaling_compute_scale_down_enabled" {
  type        = bool
  default     = false
  description = "Set to true to enable the cluster tier to scale down. This option is only available if autoScaling.compute.enabled is true."
}

variable "provider_auto_scaling_compute_max_instance_size" {
  type        = string
  default     = null
  description = "The maximum instance size when scaling up"
}

variable "provider_auto_scaling_compute_min_instance_size" {
  type        = string
  default     = null
  description = "The minimum instance size when scaling down"
}

variable "mongo_db_major_version" {
  type        = string
  default     = "5.0"
  description = "Version of the cluster to deploy. Atlas supports the following MongoDB versions for M10+ clusters: 3.6, 4.0, or 4.2. You must set this value to 4.2 if provider_instance_size_name is either M2 or M5."
}

variable "provider_name" {
  type        = string
  description = "Cloud service provider on which the servers are provisioned. The possible values are: AWS - Amazon AWS, GCP - Google Cloud Platform, AZURE - Microsoft Azure, TENANT - A multi-tenant deployment on one of the supported cloud service providers. Only valid when providerSettings.instanceSizeName is either M2 or M5."
}

variable "disk_size_gb" {
  type        = number
  description = "GCP/AWS Only) Capacity, in gigabytes, of the host’s root volume. Increase this number to add capacity, up to a maximum possible value of 4096 (i.e., 4 TB). This value must be a positive integer. The minimum disk size for dedicated clusters is 10GB for AWS and GCP. If you specify diskSizeGB with a lower disk size, Atlas defaults to the minimum disk size value. Note: The maximum value for disk storage cannot exceed 50 times the maximum RAM for the selected cluster. If you require additional storage space beyond this limitation, consider upgrading your cluster to a higher tier. Cannot be used with clusters with local NVMe SSDs"
}

variable "provider_instance_size_name" {
  type        = string
  description = "Atlas provides different instance sizes, each with a default storage capacity and RAM size. The instance size you select is used for all the data-bearing servers in your cluster. See Create a Cluster providerSettings.instanceSizeName for valid values and default resources. Note free tier (M0) creation is not supported by the Atlas API and hence not supported by this provider.)"
}

variable "javascript_enabled" {
  type        = bool
  description = "When true, the cluster allows execution of operations that perform server-side executions of JavaScript. When false, the cluster disables execution of those operations."
}

variable "minimum_enabled_tls_protocol" {
  type        = string
  description = "Sets the minimum Transport Layer Security (TLS) version the cluster accepts for incoming connections.Valid values are: TLS1_0, TLS1_1, TLS1_2 "
}

variable "vpc_id" {
  type        = string
  description = "VPC id"
}

variable "subnet_ids" {
  description = "Set of EC2 Subnet IDs."
  type        = list(string)
}

variable "tags" {
  description = "A list of Tags"
  type        = map(any)
}

variable "electable_nodes" {
  type        = number
  description = "Number of electable nodes for Atlas to deploy to the region. Electable nodes can become the primary and can facilitate local reads. The total number of electableNodes across all replication spec regions must total 3, 5, or 7. Specify 0 if you do not want any electable nodes in the region. You cannot create electable nodes in a region if priority is 0."
}

variable "priority" {
  type        = number
  description = " Election priority of the region. For regions with only read-only nodes, set this value to 0. For regions where electable_nodes is at least 1, each region must have a priority of exactly one (1) less than the previous region. The first region must have a priority of 7. The lowest possible priority is 1. The priority 7 region identifies the Preferred Region of the cluster. Atlas places the primary node in the Preferred Region. Priorities 1 through 7 are exclusive - no more than one region per cluster can be assigned a given priority. Example: If you have three regions, their priorities would be 7, 6, and 5 respectively. If you added two more regions for supporting electable nodes, the priorities of those regions would be 4 and 3 respectively."
}

variable "read_only_nodes" {
  type        = number
  description = "Number of read-only nodes for Atlas to deploy to the region. Read-only nodes can never become the primary, but can facilitate local-reads. Specify 0 if you do not want any read-only nodes in the region."
}

variable "ingress_rule" {
  type        = list(any)
  description = "A list of ingress rules"
  default = [
    {
      description      = "All ports from internal addresses"
      from_port        = 0
      to_port          = 65535
      protocol         = "tcp"
      cidr_blocks      = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16", "100.64.0.0/16"]
      ipv6_cidr_blocks = []
    },
  ]
}

variable "egress_rule" {
  type        = list(any)
  description = "A list of ingress rules"
  default = [
    {
      description      = "All"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    },
  ]
}
