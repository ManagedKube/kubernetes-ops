# module "manifest_set" {
#     source = "github.com/ManagedKube/kubernetes-ops.git//terraform-modules/aws/kubernetes/manifest_set?ref=gha-testkube"

#     upload_directory = "${path.module}/yaml"
# }


resource "kubernetes_manifest" "this" {
  for_each = fileset("./yaml", "*")
  manifest = yamldecode(file("${path.module}/yaml/${each.value}"))
}

