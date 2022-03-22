module "manifest_set" {
    source = "github.com/ManagedKube/kubernetes-ops.git//terraform-modules/aws/kubernetes/manifest_set?ref=gha-testkube"

    upload_source_path = path.cwd
    upload_directory   = "yaml"
}
