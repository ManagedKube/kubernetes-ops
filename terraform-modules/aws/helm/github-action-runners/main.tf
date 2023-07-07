resource "kubernetes_manifest" "runnerdeployment_self_hosted_runners" {
  for_each = var.runner_configs
  manifest = {
    "apiVersion" = "actions.summerwind.dev/v1alpha1"
    "kind" = "RunnerDeployment"
    "metadata" = {
      "name" = each.key
      "namespace" = "self-hosted-runners"
    }
    "spec" = {
      "effectiveTime" = null
      "replicas" = 1
      "selector" = null
      "template" = {
        "metadata" = {}
        "spec" = {
          "dockerdContainerResources" = {}
          "env" = [
            {
              "name" = "RUNNER_EPHEMERAL"
              "value" = "false"
            },
          ]
          "image" = ""
          "labels" = each.value.runner_labels
          "repository" = each.value.repository
          "resources" = {
            "limits" = {
              "cpu" = "2"
              "memory" = "4Gi"
            }
            "requests" = {
              "cpu" = "1"
              "memory" = "2Gi"
            }
          }
        }
      }
    }
  }
}


resource "kubernetes_manifest" "horizontalrunnerautoscaler_self_hosted_runners" {
  for_each = var.runner_configs
  manifest = {
    "apiVersion" = "actions.summerwind.dev/v1alpha1"
    "kind" = "HorizontalRunnerAutoscaler"
    "metadata" = {
      "name" = "${each.key}-autoscaler"
      "namespace" = "self-hosted-runners"
    }
    "spec" = {
      "maxReplicas" = 10
      "metrics" = [
        {
          "repositoryNames" = each.value.hra_repositories
          "type" = "TotalNumberOfQueuedAndInProgressWorkflowRuns"
        },
      ]
      "minReplicas" = 1
      "scaleTargetRef" = {
        "kind" = "RunnerDeployment"
        "name" = each.key
      }
    }
  }
}

