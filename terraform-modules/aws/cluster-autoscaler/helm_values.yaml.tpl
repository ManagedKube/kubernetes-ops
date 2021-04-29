awsRegion: ${awsRegion}

rbac:
  create: true
  serviceAccount:
    # This value should match local.k8s_service_account_name in locals.tf
    name: ${serviceAccountName}
    annotations:
      # This value should match the ARN of the role created by module.iam_assumable_role_admin in irsa.tf
      eks.amazonaws.com/role-arn: "arn:aws:iam::${awsAccountID}:role/cluster-autoscaler-${clusterName}"

autoDiscovery:
  clusterName: ${clusterName}
  enabled: true
