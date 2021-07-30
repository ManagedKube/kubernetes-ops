# Terraform Troubeshooting

## AWS 403

```
Terraform v0.15.1
on linux_amd64
Configuring remote state backend...
Initializing Terraform configuration...
╷
│ Error: error configuring Terraform AWS Provider: error validating provider credentials: error calling sts:GetCallerIdentity: InvalidClientTokenId: The security token included in the request is invalid.
│ status code: 403, request id: dbd162e1-7207-43cc-b4ab-dd6944107e2e
│
│ with provider["registry.terraform.io/hashicorp/aws"],
│ on main.tf line 21, in provider "aws":
│ 21: provider "aws" {
│
╵
```

This is most likely that the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variable in Terraform cloud is incorrect.

Check to make sure you entered in the correct AWS access keys.

