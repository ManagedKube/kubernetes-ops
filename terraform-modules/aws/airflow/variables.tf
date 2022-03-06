variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}

variable "cluster_name" {
  type        = string
  default     = "cluster"
  description = "EKS cluster name"
}

variable "airflow_legacyCommands" {
  type        = bool
  default     = false
  description = "if we use legacy 1.10 airflow commands"
}

variable "airflow_image" {}

variable "airflow_executor" {
  type        = string
  default     = "CeleryExecutor"
  description = <<EOT
    the airflow executor type to use
    - allowed values: "CeleryExecutor", "KubernetesExecutor", "CeleryKubernetesExecutor"
    - customize the "KubernetesExecutor" pod-template with `airflow.kubernetesPodTemplate.*`
  EOT
}

variable "airflow_fernetKey" {
  type        = string
  default     = "7T512UXSSmBOkpWimFHIVb8jK6lfmSAvx4mO6Arehnc="
  description = <<EOT
    the fernet encryption key (sets `AIRFLOW__CORE__FERNET_KEY`)
    - [WARNING] you must change this value to ensure the security of your airflow
    - set `AIRFLOW__CORE__FERNET_KEY` with `airflow.extraEnv` from a Secret to avoid storing this in your values
    - use this command to generate your own fernet key:
     python -c "from cryptography.fernet import Fernet; FERNET_KEY = Fernet.generate_key().decode(); print(FERNET_KEY)"
  EOT
}

variable "airflow_webserverSecretKey" {
  type        = string
  default     = "THIS IS UNSAFE!"
  description = <<EOT
    environment variables for airflow configs
    - airflow env-vars are structured: "AIRFLOW__{config_section}__{config_name}"
    - airflow configuration reference:
     https://airflow.apache.org/docs/apache-airflow/stable/configurations-ref.html

    ____ EXAMPLE _______________
     config:
       # dag configs
       AIRFLOW__CORE__LOAD_EXAMPLES: "False"
       AIRFLOW__SCHEDULER__DAG_DIR_LIST_INTERVAL: "30"

       # email configs
       AIRFLOW__EMAIL__EMAIL_BACKEND: "airflow.utils.email.send_email_smtp"
       AIRFLOW__SMTP__SMTP_HOST: "smtpmail.example.com"
       AIRFLOW__SMTP__SMTP_MAIL_FROM: "admin@example.com"
       AIRFLOW__SMTP__SMTP_PORT: "25"
       AIRFLOW__SMTP__SMTP_SSL: "False"
       AIRFLOW__SMTP__SMTP_STARTTLS: "False"

       # domain used in airflow emails
       AIRFLOW__WEBSERVER__BASE_URL: "http://airflow.example.com"

       # ether environment variables
       HTTP_PROXY: "http://proxy.example.com:8080"

  EOT
}

variable "airflow_config" {
  type        = list()
  default     = {}
  description = <<EOT
    environment variables for airflow configs
    - airflow env-vars are structured: "AIRFLOW__{config_section}__{config_name}"
    - airflow configuration reference:
     https://airflow.apache.org/docs/apache-airflow/stable/configurations-ref.html

    ____ EXAMPLE _______________
     config:
       # dag configs
       AIRFLOW__CORE__LOAD_EXAMPLES: "False"
       AIRFLOW__SCHEDULER__DAG_DIR_LIST_INTERVAL: "30"

       # email configs
       AIRFLOW__EMAIL__EMAIL_BACKEND: "airflow.utils.email.send_email_smtp"
       AIRFLOW__SMTP__SMTP_HOST: "smtpmail.example.com"
       AIRFLOW__SMTP__SMTP_MAIL_FROM: "admin@example.com"
       AIRFLOW__SMTP__SMTP_PORT: "25"
       AIRFLOW__SMTP__SMTP_SSL: "False"
       AIRFLOW__SMTP__SMTP_STARTTLS: "False"

       # domain used in airflow emails
       AIRFLOW__WEBSERVER__BASE_URL: "http://airflow.example.com"

       # ether environment variables
       HTTP_PROXY: "http://proxy.example.com:8080"

  EOT
}

variable "airflow_users" {
  type        = list()
  default     = <<EOT
    - username: admin
      password: admin
      role: Admin
      email: admin@example.com
      firstName: admin
      lastName: admin
  EOT
  description = <<EOT
    a list of users to create
    - templates can ONLY be used in: `password`, `email`, `firstName`, `lastName`
    - templates used a bash-like syntax: {MY_USERNAME}, $MY_USERNAME
    - templates are defined in `usersTemplates`
  EOT
}

variable "airflow_usersTemplates" {
  type        = list()
  default     = {}
  description = <<EOT
    bash-like templates to be used in `airflow.users`
    - [WARNING] if a Secret or ConfigMap is missing, the sync Pod will crash
    - [WARNING] all keys must match the regex: ^[a-zA-Z_][a-zA-Z0-9_]*$

    ____ EXAMPLE _______________
     usersTemplates
       MY_USERNAME:
         kind: configmap
         name: my-configmap
         key: username
       MY_PASSWORD:
         kind: secret
         name: my-secret
         key: password
  EOT
}

variable "airflow_usersUpdate" {
  type        = bool
  default     = true
  description = <<EOT
    if we create a Deployment to perpetually sync `airflow.users`
    - when `true`, users are updated in real-time, as ConfigMaps/Secrets change
    - when `true`, users changes from the WebUI will be reverted automatically
    - when `false`, users will only update one-time, after each `helm upgrade`
  EOT
}

variable "airflow_connections" {
  type        = list(any)
  default     = []
  description = <<EOT
    a list airflow connections to create
    - templates can ONLY be used in: `host`, `login`, `password`, `schema`, `extra`
    - templates used a bash-like syntax: {AWS_ACCESS_KEY} or $AWS_ACCESS_KEY
    - templates are defined in `connectionsTemplates`

    ____ EXAMPLE _______________
     connections:
       - id: my_aws
         type: aws
         description: my AWS connection
         extra: |-
           { "aws_access_key_id": "{AWS_KEY_ID}",
             "aws_secret_access_key": "{AWS_ACCESS_KEY}",
             "region_name":"eu-central-1" }
  EOT
}

variable "airflow_connectionsUpdate" {
  type        = bool
  default     = true
  description = <<EOT
    bash-like templates to be used in `airflow.connections`
    - see docs for `airflow.usersTemplates`
  EOT
}

variable "airflow_variables" {
  type        = list(any)
  default     = []
  description = <<EOT
    a list airflow variables to create
    - templates can ONLY be used in: `value`
    - templates used a bash-like syntax: {MY_VALUE} or $MY_VALUE
    - templates are defined in `connectionsTemplates`

    ____ EXAMPLE _______________
     variables:
       - key: "var_1"
         value: "my_value_1"
       - key: "var_2"
         value: "my_value_2"
  EOT
}

variable "airflow_variablesTemplates" {
  type        = list()
  default     = {}
  description = <<EOT
    bash-like templates to be used in `airflow.variables`
    - see docs for `airflow.usersTemplates`
  EOT
}

variable "airflow_variablesUpdate" {
  type        = bool
  default     = true
  description = <<EOT
    if we create a Deployment to perpetually sync `airflow.variables`
    - see docs for `airflow.usersUpdate`
  EOT
}

variable "airflow_pools" {
  type        = list(any)
  default     = []
  description = <<EOT
    a list airflow pools to create

    ____ EXAMPLE _______________
     pools:
       - name: "pool_1"
         description: "example pool with 5 slots"
         slots: 5
       - name: "pool_2"
         description: "example pool with 10 slots"
         slots: 10
  EOT
}

variable "airflow_poolsUpdate" {
  type        = bool
  default     = true
  description = <<EOT
    if we create a Deployment to perpetually sync `airflow.pools`
    - see docs for `airflow.usersUpdate`
  EOT
}

variable "airflow_defaultNodeSelector" {
  type        = list()
  default     = {}
  description = <<EOT
    default nodeSelector for airflow Pods (is overridden by pod-specific values)
    - docs for nodeSelector:
     https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector
  EOT
}

variable "airflow_defaultAffinity" {
  type        = list()
  default     = {}
  description = <<EOT
    default affinity configs for airflow Pods (is overridden by pod-specific values)
    - spec for Affinity:
     https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.20/#affinity-v1-core
  EOT
}

variable "airflow_defaultTolerations" {
  type        = list(any)
  default     = []
  description = <<EOT
    default toleration configs for airflow Pods (is overridden by pod-specific values)
    - spec for Toleration:
     https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.20/#toleration-v1-core
  EOT
}

variable "airflow_defaultSecurityContext" {
  type        = map()
  default     = <<EOT
    fsGroup: 0
  EOT
  description = <<EOT
    sets the filesystem owner group of files/folders in mounted volumes
    this does NOT give root permissions to Pods, only the "root" group
  EOT
}

variable "airflow_podAnnotations" {
  type        = list()
  default     = {}
  description = "extra annotations for airflow Pods"
}

variable "airflow_extraPipPackages" {
  type        = list(any)
  default     = []
  description = <<EOT
    extra environment variables for the airflow Pods
    - spec for EnvVar:
     https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.20/#envvar-v1-core
  EOT
}

variable "airflow_extraEnv" {
  type        = list(any)
  default     = []
  description = <<EOT
    extra environment variables for the airflow Pods
    - spec for EnvVar:
     https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.20/#envvar-v1-core
  EOT
}

variable "airflow_extraContainers" {
  type        = list(any)
  default     = []
  description = <<EOT
    extra containers for the airflow Pods
    - spec for Container:
     https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.20/#container-v1-core
  EOT
}

variable "airflow_extraVolumeMounts" {
  type        = list(any)
  default     = []
  description = <<EOT
    extra VolumeMounts for the airflow Pods
    - spec for VolumeMount:
     https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.20/#volumemount-v1-core
  EOT
}

variable "airflow_extraVolumes" {
  type        = list(any)
  default     = []
  description = <<EOT
    extra Volumes for the airflow Pods
    - spec for Volume:
     https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.20/#volume-v1-core
  EOT
}
