module "manifest_set" {
    source = "github.com/ManagedKube/kubernetes-ops.git//terraform-modules/aws/kubernetes/manifest_set?ref=v2.0.12"

    upload_source_path = path.cwd
    upload_directory   = "yaml"
    fileset_pattern    = "**/*.yaml.tftpl"
    template_vars      = {
        namespace = var.app_namespace
    }
}
