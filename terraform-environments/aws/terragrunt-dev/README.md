# terragrunt-dev

This is a version of kubernetes-ops where it uses the same Terraform modules but uses terragrunt
to wrap around Terraform for instantiation.  Terragrunt helps us out with DRYing the configurations.
For example, we don't have to repeat the backend state store information in every usage like we
would if we were just using pure Terraform.
