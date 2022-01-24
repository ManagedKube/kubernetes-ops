# data "aws_eks_cluster_auth" "main" {
#   name = var.cluster_name
# }

# provider "kubectl" {
#   host                   = var.kubernetes_api_host
#   cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
#   token                  = data.aws_eks_cluster_auth.main.token
#   load_config_file       = false
# }

# # file templating
# data "template_file" "gateway" {
#   template = file("${path.module}/gateway.tpl.yaml")

#   vars = {
#     namespace  = var.namespace
#   }
# }

# resource "kubectl_manifest" "gateway" {
#   yaml_body = data.template_file.gateway.rendered
# }





# provider "kubernetes" {
#   config_path    = "~/.kube/config"
#   config_context = "my-context"
# }

resource "kubernetes_namespace" "example" {
  metadata {
    annotations = {
      name = "example-annotation"
    }

    labels = {
      mylabel = "label-value"
    }

    name = "terraform-example-namespace"
  }
}


