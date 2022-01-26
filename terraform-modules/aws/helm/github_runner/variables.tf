variable "user_chart_name" {
  default = "actions-runner-controller"
  description = "The Helm name to install this chart under"
}

variable "helm_chart_version" {
  default = "0.15.1"
  description = "The version of this helm chart to use"
}

variable "k8s_namespace" {
  default = "actions-runner-controller"
}

variable "helm_values_2" {
  type = string
  default = ""
  description = "Helm values that will overwrite the helm chart defaults and this modules default for further user customization"
}

variable "enable_kubernetes_external_secret" {
  type        = bool
  description = "To create the kubernetes-external-secret or not.  Only if you are using the kubernetes-external-secret controller"
  default     = false
}

variable "kubernetes_external_secret_name" {
  type        = string
  description = "The kubernetes-external secret name and the secret name.  enable_kubernetes_external_secret must be set to true"
  default     = "controller-manager"
}

variable "aws_secret_name" {
  type        = string
  description = "The name of the AWS Secret to pull from.  enable_kubernetes_external_secret must be set to true"
  default     = "github_token" 
}

variable "k8s_secret_key_name" {
  type        = string
  description = "The key name in the k8s secret.  enable_kubernetes_external_secret must be set to true"
  default     = "github_token"
}

variable "runner_repository_name" {
  type = string
  description = "Runner config.  The repository name to associate this runner to"
  default = null
}
