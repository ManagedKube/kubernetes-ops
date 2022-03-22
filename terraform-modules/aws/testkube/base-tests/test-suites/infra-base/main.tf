# module "manifest_set" {
#     source = "github.com/ManagedKube/kubernetes-ops.git//terraform-modules/aws/kubernetes/manifest_set?ref=gha-testkube"

#     upload_source_path = path.cwd
#     upload_directory   = "yaml"
# }

# resource "kubernetes_manifest" "this" {
#   for_each = fileset(var.upload_directory, "**/*.*")
#   manifest = yamldecode(file("${var.upload_source_path}/${var.upload_directory}/${each.value}"))
# }

variable "upload_directory" {
  type        = string
  default     = "yaml"
  description = "description"
}


resource "kubernetes_manifest" "this" {
  for_each = fileset(var.upload_directory, "**/*.*")
  manifest = yamldecode(file("${path.cwd}/${var.upload_directory}/${each.value}"))
}

resource "kubernetes_manifest" "that" {
#   for_each = fileset(var.upload_directory, "**/*.*")
  manifest = yamldecode(file("./yaml/ts.yaml"))
}
