## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_db"></a> [db](#module\_db) | terraform-aws-modules/rds/aws | ~> 3.0 |
| <a name="module_security_group"></a> [security\_group](#module\_security\_group) | terraform-aws-modules/security-group/aws | ~> 4 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allocated_storage"></a> [allocated\_storage](#input\_allocated\_storage) | The allocated storage in gigabytes | `string` | `100` | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | The days to retain backups for | `number` | `"0"` | no |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance\_window | `string` | `"03:00-06:00"` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | The database can't be deleted when this value is set to true. | `bool` | `true` | no |
| <a name="input_engine"></a> [engine](#input\_engine) | The database engine to use | `string` | `"postgres"` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | The engine version to use | `string` | `"11.12"` | no |
| <a name="input_family"></a> [family](#input\_family) | The family of the DB parameter group | `string` | `"postgres11"` | no |
| <a name="input_identifier"></a> [identifier](#input\_identifier) | The name of the RDS instance, if omitted, Terraform will assign a random, unique identifier | `string` | n/a | yes |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | The instance type of the RDS instance | `string` | `"db.t3.large"` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00' | `string` | `"Mon:00:00-Mon:03:00"` | no |
| <a name="input_major_engine_version"></a> [major\_engine\_version](#input\_major\_engine\_version) | Specifies the major version of the engine that this option group should be associated with | `string` | `"11"` | no |
| <a name="input_max_allocated_storage"></a> [max\_allocated\_storage](#input\_max\_allocated\_storage) | Specifies the value for Storage Autoscaling | `number` | `1024` | no |
| <a name="input_name"></a> [name](#input\_name) | The DB name to create. If omitted, no database is created initially | `string` | `null` | no |
| <a name="input_parameters"></a> [parameters](#input\_parameters) | A list of DB parameters (map) to apply | `list(map(string))` | <pre>[<br>  {<br>    "name": "autovacuum",<br>    "value": 1<br>  },<br>  {<br>    "name": "client_encoding",<br>    "value": "utf8"<br>  }<br>]</pre> | no |
| <a name="input_password"></a> [password](#input\_password) | Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file | `string` | `null` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | A list of private subnets | `list(any)` | n/a | yes |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final\_snapshot\_identifier | `bool` | `false` | no |
| <a name="input_storage_encrypted"></a> [storage\_encrypted](#input\_storage\_encrypted) | Specifies whether the DB instance is encrypted | `bool` | `true` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD). The default is 'io1' if iops is specified, 'gp2' if not. | `string` | `"gp2"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br>  "ops_env": "staging",<br>  "ops_managed_by": "terraform",<br>  "ops_owners": "devops",<br>  "ops_source_repo": "kubernetes-ops",<br>  "ops_source_repo_path": "terraform-module/aws/postgres"<br>}</pre> | no |
| <a name="input_username"></a> [username](#input\_username) | Username for the master DB user | `string` | `null` | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | The CIDR block of the VPC | `any` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_db_instance_endpoint"></a> [db\_instance\_endpoint](#output\_db\_instance\_endpoint) | The connection endpoint |
