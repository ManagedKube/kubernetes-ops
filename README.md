# ht-devops

## Terraform
We are using Terragrunt as a helper to keep Terraform DRY.

### Terragrunt

Download:  https://github.com/gruntwork-io/terragrunt

### AWS Authentication
There are multiple ways to set your AWS authentication access.

Exporting AWS keys to your local envars
```
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
```

You can set them in your AWS profile config: ~/.aws/config

### Usage

#### Create VPC

Directory: ./tf-environments/dev/vpc

Run:
```
terragrunt apply
```
# kubernetes-ops
