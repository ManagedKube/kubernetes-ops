module "kiali_operator" {
  source = "git::https://github.com/DNXLabs/terraform-aws-eks-kiali-operator.git"

  enabled = true
  namespace = var.namespace

}


