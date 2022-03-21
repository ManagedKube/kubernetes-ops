# Uploads all of the files in the pass in dir path
resource "kubernetes_manifest" "this" {
  for_each = fileset(local.upload_directory, "**/*.*")
  manifest = yamldecode(each.value)
}
