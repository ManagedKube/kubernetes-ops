resource "aws_guardduty_detector" "guardduty_detector" {
  enable = var.guardduty_enabled
  tags = var.tags
    datasources {
        s3_logs {
            enable = var.guardduty_s3_logs_enabled
        }
        malware_protection {
            scan_ec2_instance_with_findings {
                ebs_volumes {
                enable = var.guardduty_malware_protection_logs_enabled
                }
            }
        }
    }
}
