data "aws_eks_cluster" "cluster" {
  name = "${eks_cluster_name}"
}

// provider "kubernetes" {
//   host                   = data.aws_eks_cluster.cluster.endpoint
//   cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)

//   # EKS clusters use short-lived authentication tokens that can expire in the middle of an 'apply' or 'destroy'. To
//   # avoid this issue, we use an exec-based plugin here to fetch an up-to-date token. Note that this code requires the
//   # kubergrunt binary to be installed and on your PATH.
//   exec {
//     api_version = "client.authentication.k8s.io/v1alpha1"
//     command     = "${kubergrunt_exec}"
//     args        = ["eks", "token", "--cluster-id", "${eks_cluster_name}"]
//   }
// }

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
    command     = "aws"
  }
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)

    # EKS clusters use short-lived authentication tokens that can expire in the middle of an 'apply' or 'destroy'. To
    # avoid this issue, we use an exec-based plugin here to fetch an up-to-date token. Note that this code requires the
    # kubergrunt binary to be installed and on your PATH.
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      // command     = "${kubergrunt_exec}"
      command     = "aws"
      args        = ["eks", "token", "--cluster-id", "${eks_cluster_name}"]
    }
  }
}
