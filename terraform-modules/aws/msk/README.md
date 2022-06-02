# msk
This module creates an AWS Managed Streaming for Apache Kafka (MSK).

This module is based off the work of another module located here:
https://github.com/cloudposse/terraform-aws-msk-apache-kafka-cluster

In addition to creating an MSK broker, running this module will create:
* An MSK broker with 2 nodes in each defined subnet, maximum of 3 subnets. 
* Creates an s3 bucket if the user decides MSK logs should be delivered to an S3 bucket
* A Cloudwatch Log group if Cloudwatch logging is enabled and a group is specified. 


# How to run the unit tests
Note that the provisioning of an MSK cluster takes about 30 minutes. 

```
cd test
go test ./ -v -timeout=999m
```

no cache run
```
go test ./ -v -count=1
```

## How to run the debugger

TBD

## Connecting to the MSK cluster doc

https://docs.aws.amazon.com/msk/latest/developerguide/create-client-machine.html
