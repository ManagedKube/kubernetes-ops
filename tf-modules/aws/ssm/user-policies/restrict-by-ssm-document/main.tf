terraform {
  backend "s3" {
  }
}

resource "aws_iam_policy" "policy" {
  name        = var.name
  description = "A policy to restrict user by an SSM document."
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "OpsSSMPolicy0",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeInstances",
                "ssm:GetConnectionStatus",
                "ssm:DescribeSessions",
                "ssm:DescribeInstanceProperties"
            ],
            "Resource": "*"
        },
        {
            "Sid": "OpsSSMPolicy1",
            "Effect": "Allow",
            "Action": "ssm:StartSession",
            "Resource": [
                "arn:aws:ec2:*:*:instance/*",
                "arn:aws:ssm:*:*:document/${var.document_name}"
            ],
            "Condition": {
                "BoolIfExists": {
                    "ssm:SessionDocumentAccessCheck": "true" 
                }
            }
        },
        {
            "Sid": "OpsSSMPolicy2",
            "Effect": "Allow",
            "Action": "ssm:TerminateSession",
            "Resource": "arn:aws:ssm:*:*:session/$${aws:username}-*"
        }
    ]
}
EOF
}
