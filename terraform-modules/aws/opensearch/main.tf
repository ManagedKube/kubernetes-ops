resource "aws_opensearch_domain" "this" {
  domain_name             = var.domain_name
  engine_version          = "Elasticsearch_7.10"

  cluster_config {
    instance_type = "r4.large.search"
    zone_awareness_enabled = true
    instance_count = var.instance_count
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }

  encrypt_at_rest {
    enabled = true
  }

  node_to_node_encryption {
    enabled = true
  }

  domain_endpoint_options {
    enforce_https                   = true
    tls_security_policy             = "Policy-Min-TLS-1-2-2019-07"
  }

  vpc_options {
    security_group_ids = [aws_security_group.opensearch_sg.id]
    subnet_ids         = var.subnet_ids
  }

  access_policies = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "es:*"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Resource = "arn:aws:es:${var.aws_region}:${var.account_id}:domain/${var.domain_name}/*"
        Condition = {
          Bool = {
            "aws:SecureTransport" = "true"
          }
        }
      }
    ]
  })

  depends_on = [aws_security_group.opensearch_sg]
}

resource "aws_security_group" "opensearch_sg" {
  name        = "${var.domain_name}-sg"
  description = "Security group for OpenSearch domain"
  vpc_id      = var.vpc_id

 dynamic "ingress" {
    for_each = var.ingress_rule
    content {
      description      = ingress.value["description"]
      from_port        = ingress.value["from_port"]
      to_port          = ingress.value["to_port"]
      protocol         = ingress.value["protocol"]
      cidr_blocks      = ingress.value["cidr_blocks"]
      ipv6_cidr_blocks = ingress.value["ipv6_cidr_blocks"]
    }
  }

  dynamic "egress" {
    for_each = var.egress_rule
    content {
      description      = egress.value["description"]
      from_port        = egress.value["from_port"]
      to_port          = egress.value["to_port"]
      protocol         = egress.value["protocol"]
      cidr_blocks      = egress.value["cidr_blocks"]
      ipv6_cidr_blocks = egress.value["ipv6_cidr_blocks"]
    }
  }

  tags = var.tags
}
