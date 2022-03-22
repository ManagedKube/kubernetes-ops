# Uploads all of the files in the pass in dir path
resource "kubernetes_manifest" "this" {
  for_each = fileset(var.upload_directory, "*")
  manifest = yamldecode(tostring(each.value))
}
