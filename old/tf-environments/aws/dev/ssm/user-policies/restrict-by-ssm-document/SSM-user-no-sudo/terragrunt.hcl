include {
  path = find_in_parent_folders()
}

terraform {
  source = "git::ssh://git@github.q-internal.tech/qadium/terraform-modules.git//aws/ssm/user-policies/restrict-by-ssm-document?ref=v1.14.12"
}

inputs = {

  name = "SSM-user-no-sudo"
  document_name = "SSM-no-sudo"
}
