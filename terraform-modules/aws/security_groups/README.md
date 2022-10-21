# AWS Security Group
This creates a set of security groups that can be used on other items.

## Retrieving the security group by name:

The `sg_list` output data structure:
```
sg_list = {
  "id" = [
    "sg-0978d62cacw3e8b21",
    "sg-06f385f8d8w319d59",
    "sg-033cc7d494w3cbe47",
    "sg-0071a0c41bwaea18e",
  ]
  "name" = [
    "dev-foo",
    "dev-app",
    "dev-bar",
    "dev-ami",
  ]
```

Can use the `index` function to find an index by the name:
```
module.security_groups.sg_list["id"][index(module.security_groups.sg_list["name"], "dev-app")]
```