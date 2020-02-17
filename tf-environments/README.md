Folder Layout
==============

The folders are split into clouds.  There is a folder for `aws` and another folder for `gcp`.  The main reason for this is that the state store configurations are a little different for each of these clouds.  To keep everything "DRY" it is easier to split them up by clouds instead of by the environment it is.

# AWS

In the `aws` folder there is a `terragrunt.hcl` file the puts the state store into:

```
bucket = "kubernetes-ops-tf-state-${get_aws_account_id()}-terraform-state"
```

S3 buckets has to be globally unique accross all of their customers.  The `terragrunt.hcl` file is set to get the current AWS account number and put it in the bucket name making it unique.  For most cases this should work well.

Usually you would use new account for dev, qa, and prod.  This means launching those environments, it would put the state store in the correct account's S3 bucket with the accounts ID in the bucket name.

# GCP
In the `gcp` folder there is a `terragrunt.hcl` file that puts the state store into:

```
bucket = "kubernetes-ops-terraform-state-${get_env("STATE_STORE_UNIQUE_KEY", "default-value-1234")}"
```

Terragrunt does not provide us with a handy function to get the account or project id.  We have to set that as a unique key.  A good key to use would be the project name or the ID.  You have to export the variable to your environment: `STATE_STORE_UNIQUE_KEY`
