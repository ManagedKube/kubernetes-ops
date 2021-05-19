resource "aws_iam_instance_profile" "profile" {
  name = "OpsEC2SSM${var.name}"
  role = aws_iam_role.role.name
}

resource "aws_iam_role" "role" {
  name = "OpsEC2SSM${var.name}"

  description = "Allows EC2 instances to call AWS services on your behalf with SSM."

  force_detach_policies = true

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "role_attach" {
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_policy" "ssm_policy" {
  name        = "OpsEC2SSM${var.name}"
  description = "A policy for an instance with the SSM settings"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ssmmessages:CreateControlChannel",
                "ssmmessages:CreateDataChannel",
                "ssmmessages:OpenControlChannel",
                "ssmmessages:OpenDataChannel",
                "ssm:UpdateInstanceInformation"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetEncryptionConfiguration"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "kms:GenerateDataKey",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ssm_policy_attach" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.ssm_policy.arn
}

resource "aws_iam_policy" "ssm_policy_s3" {
  name        = "OpsEC2S3Access${var.name}"
  description = "A policy for an instance with permissions to the S3 session logs bucket"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::${var.s3_bucket_name}/${var.s3_bucket_prefix}",
                "arn:aws:s3:::${var.s3_bucket_name}/${var.s3_bucket_prefix}/*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ssm_policy_attach_s3" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.ssm_policy_s3.arn
}
