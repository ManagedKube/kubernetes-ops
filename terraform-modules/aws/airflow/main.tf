locals {
  name = "airflow"
}

data "aws_caller_identity" "current" {}

#
# Helm - ${local.name}
#
data "template_file" "helm_values" {
  template = file("${path.module}/values.yaml")
  vars = {
    awsAccountID                   = data.aws_caller_identity.current.account_id
    awsRegion                      = var.aws_region
    clusterName                    = var.cluster_name
    airflow_image                  = var.airflow_image
    airflow_executor               = var.airflow_executor
    airflow_fernetKey              = var.airflow_fernetKey
    airflow_webserverSecretKey     = var.airflow_webserverSecretKey
    airflow_config                 = var.airflow_config
    airflow_users                  = var.airflow_users
    airflow_usersTemplates         = var.airflow_usersTemplates
    airflow_usersUpdate            = var.airflow_usersUpdate
    airflow_connections            = var.airflow_connections
    airflow_connectionsUpdate      = var.airflow_connectionsUpdate
    airflow_variables              = var.airflow_variables
    airflow_variablesTemplates     = var.airflow_variablesTemplates
    airflow_variablesUpdate        = var.airflow_variablesUpdate
    airflow_pools                  = var.airflow_pools
    airflow_poolsUpdate            = var.airflow_poolsUpdate
    airflow_defaultNodeSelector    = var.airflow_defaultNodeSelector
    airflow_defaultAffinity        = var.airflow_defaultAffinity
    airflow_defaultTolerations     = var.airflow_defaultTolerations
    airflow_defaultSecurityContext = var.airflow_defaultSecurityContext
    airflow_podAnnotations         = var.airflow_podAnnotations
    airflow_extraPipPackages       = var.airflow_extraPipPackages
    airflow_extraEnv               = var.airflow_extraEnv
    airflow_extraContainers        = var.airflow_extraContainers
    airflow_extraVolumeMounts      = var.airflow_extraVolumeMounts
    airflow_extraVolumes           = var.airflow_extraVolumes
  }
}

module "apache-airflow" {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/helm/helm_generic?ref=v2.0.1"

  # https://airflow.apache.org/docs/helm-chart/stable/index.html
  repository          = "https://airflow.apache.org"
  official_chart_name = local.name
  user_chart_name     = local.name
  helm_version        = "1.4.0"
  namespace           = local.name
  helm_values         = data.template_file.helm_values.rendered

}
