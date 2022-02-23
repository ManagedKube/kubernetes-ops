resource "kubernetes_manifest" "clusterrole_kube_system_eks_user_read_only_access_cr" {
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "ClusterRole"
    "metadata" = {
      "name" = "eks-user-read-only-access-cr"
      "namespace" = "kube-system"
    }
    "rules" = [
      {
        "apiGroups" = [
          "",
          "apps",
          "batch",
          "extensions",
          "batch",
          "autoscaling",
          "networking.istio.io",
        ]
        "resources" = [
          "deployments",
          "daemonsets",
          "statefulsets",
          "replicasets",
          "services",
          "ingresses",
          "events",
          "pods/log",
          "virtualservices",
          "gateway",
          "pods",
          "nodes",
          "replicationcontrollers",
          "cronjobs",
          "gateways",
          "horizontalpodautoscalers",
        ]
        "verbs" = [
          "get",
          "list",
        ]
      },
      {
        "apiGroups" = [
          "batch",
        ]
        "resources" = [
          "jobs",
        ]
        "verbs" = [
          "get",
          "list",
        ]
      },
    ]
  }
}

resource "kubernetes_manifest" "clusterrolebinding_kube_system_user_read_only_access_cr_binding" {
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "ClusterRoleBinding"
    "metadata" = {
      "name" = "user-read-only-access-cr-binding"
      "namespace" = "kube-system"
    }
    "roleRef" = {
      "apiGroup" = "rbac.authorization.k8s.io"
      "kind" = "ClusterRole"
      "name" = "eks-user-read-only-access-cr"
    }
    "subjects" = [
      {
        "apiGroup" = "rbac.authorization.k8s.io"
        "kind" = "Group"
        "name" = "eks-read-only-group"
      },
    ]
  }
}
