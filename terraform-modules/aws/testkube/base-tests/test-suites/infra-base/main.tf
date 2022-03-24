module "manifest_set" {
    source = "github.com/ManagedKube/kubernetes-ops.git//terraform-modules/aws/kubernetes/manifest_set?ref=manifest_set"

    upload_source_path = path.cwd
    upload_directory   = "yaml"
}
