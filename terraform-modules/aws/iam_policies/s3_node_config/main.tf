# Policy for S3 Bucket - allows the node to get read-only access to s3 buckets for the node_config items
# For the "all" nodes
resource "aws_iam_policy" "this" {
  name  = var.name
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : ["s3:GetObject", "s3:ListBucket"],
        "Effect" : "Allow",
        "Resource" : "arn:aws:s3:::${var.environment_name}-installer/node_configs/*"
      }
    ]
  })
}
