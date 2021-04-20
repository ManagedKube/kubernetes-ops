resource "aws_kms_key" "eks" {
  description         = "KMS key for EKS"
  enable_key_rotation = true

  tags = var.tags

  policy = <<POLICY
  {
    "Id": "key-consolepolicy-3",
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "Enable IAM User Permissions",
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::${var.account_id}:root"
        },
        "Action": "kms:*",
        "Resource": "*"
      },
      {
        "Sid": "Allow use of the key",
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::${var.account_id}:role/Administrator"
        },
        "Action": [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        "Resource": "*"
      }
    ]
  }
  POLICY
}

resource "aws_kms_alias" "eks" {
  name          = "alias/eks-${var.clustername}-encryption-key"
  target_key_id = aws_kms_key.eks.key_id
}
