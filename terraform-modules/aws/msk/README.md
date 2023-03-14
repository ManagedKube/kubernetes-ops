# msk
This module creates an AWS Managed Streaming for Apache Kafka (MSK).

This module is based off the work of another module located here:
https://github.com/cloudposse/terraform-aws-msk-apache-kafka-cluster

In addition to creating an MSK broker, running this module will create:
* An MSK broker with 2 nodes in each defined subnet, maximum of 3 subnets. 
* Creates an s3 bucket if the user decides MSK logs should be delivered to an S3 bucket
* A Cloudwatch Log group if Cloudwatch logging is enabled and a group is specified. 
