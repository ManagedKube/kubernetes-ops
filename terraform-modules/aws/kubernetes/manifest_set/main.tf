# Uploads all of the files in the pass in dir path and subdirectories
resource "kubernetes_manifest" "this" {
  for_each = fileset(var.upload_directory, var.fileset_pattern)
  manifest = yamldecode(templatefile("${var.upload_source_path}/${var.upload_directory}/${each.value}", var.template_vars))
}
