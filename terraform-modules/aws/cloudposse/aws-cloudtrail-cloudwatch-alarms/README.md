# AWS-CloudTrail-CloudWatch-Alarms

Builds AWS-CloudTrail-CloudWatch-Alarms for support to PCI-DSS certifications using this module: https://github.com/cloudposse/terraform-aws-cloudtrail-cloudwatch-alarms


**What does it solve?**

https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-cis-controls.html#cis-1.1-remediation
https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-cis-controls.html#cis-3.3-remediation
- 1.1 – Avoid the use of the "root" account
- 3.3 – Ensure a log metric filter and alarm exist for usage of "root" account

https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-cis-controls.html#securityhub-cis-controls-3.8
- 3.1 – Ensure a log metric filter and alarm exist for unauthorized API calls
- 3.2 – Ensure a log metric filter and alarm exist for AWS Management Console sign-in without MFA
- 3.4 – Ensure a log metric filter and alarm exist for IAM policy changes
- 3.5 – Ensure a log metric filter and alarm exist for CloudTrail configuration changes
- 3.6 – Ensure a log metric filter and alarm exist for AWS Management Console authentication failures
- 3.7 – Ensure a log metric filter and alarm exist for disabling or scheduled deletion of customer created CMKs
- 3.8 – Ensure a log metric filter and alarm exist for S3 bucket policy changes
- 3.9 – Ensure a log metric filter and alarm exist for AWS Config configuration changes
- 3.10 – Ensure a log metric filter and alarm exist for security group changes
- 3.11 – Ensure a log metric filter and alarm exist for changes to Network Access Control Lists (NACL)
- 3.12 – Ensure a log metric filter and alarm exist for changes to network gateways
- 3.13 – Ensure a log metric filter and alarm exist for route table changes
- 3.14 – Ensure a log metric filter and alarm exist for VPC changes
