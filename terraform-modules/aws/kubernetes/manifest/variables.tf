variable "manifest" {
  type        = string
  default     = <<EOT
apiVersion: v1
kind: ConfigMap
metadata:
  name: game-demo
  namespace: foobar
data:
  # property-like keys; each key maps to a simple value
  player_initial_lives: "3"
EOT
  description = "The yaml Kubernetes manifest to apply.  Can input via inline or from a file."
}
