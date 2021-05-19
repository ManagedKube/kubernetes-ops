# SSM Session Manager
Session Manager is a fully managed AWS Systems Manager capability that lets you manage your EC2 instances, on-premises instances, and virtual machines (VMs) through an interactive one-click browser-based shell or through the AWS CLI.

Main doc: https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager.html

The goals:
* Be able to trace back to exactly what happened on an EC2 system
* Have two classes of users.  One that can sudo and one that can not

## Be able to answer the 5 Ws
1. What happened?
1. Where did it take place?
1. When did it occur?
1. Why did it happen?
1. Who was involved?

# How users can use SSM to get a interactive shell on an EC2 node

1. Via the AWS console: AWS System Manger -> Instances & Nodes -> Session Manager -> Start session
1. Via the AWS CLI (requires the SSM plugin).  Instructions below

# Terraform Modules

## EC2 Instance IAM Role
Modules: 
* `ec2-role`

There is a role that is created that is assigned to an EC2 instance that wants to participate in this setup.  

This role gives permission for:
* SSM permissions for the node to be able to send/recieve messsages in the AWS SSM setup
* S3 bucket permissions to write logs
* KMS permissions for encryption keys

A new role for each type of SSM groups should be created.  For example, if you have a `dev` and a `prod` group, you should create two groups mirroring this structure.  The EC2 instance is given a role with write permissions to a S3 bucket and a certain part of the path.  If the role grants all access to S3 (which is a bad choice) or the entire bucket and it is shared for logs from other SSM groups, other SSM groups would be able to write to any of the paths in the bucket.  This is potentially bad if an EC2 node is compromized it would have access to overwrite logs anywhere in the bucket which then can overwrite logs for other SSM group's logs.  By creating an EC2 instance role for each group, we can then set a more restrictive S3 bucket write access to limit it to a certain path.

## User SSM Permissions
Modules:
* `user-policies/restrict-by-ssm-document`
* `user-policies/attach-policy-to-group`
* `user-policies/attach-opolicy-to-user`

Users that wants to connect to an instance via the AWS SSM setup, will need IAM permissions to do so.  

* What instances a user can connect to
* What SSM document this user must use
* SSM permissions

## VPC-Endpoints
Modules:
* `vpc-endpoints`

The EC2 nodes needs a way to get to the AWS SSM API endpoint to be able to get information and talk to the SSM control servers.  This `vpc-endpoint` puts the SSM control endpoint in the VPC where the EC2 nodes are.

## SSM Session Document
Modules: 
* `documents/sessions`

This is basically configuration for the SSM session.  When a user connects through SSM, SSM needs to know what parameters to apply to the connection.  This `document` gives SSM that information.  

Info this document/config holds:
* What user to connect to the remote system as
* S3 bucket to send the session logs to
* Encryption to use

## S3 bucket
Modules:
* `s3`

Doc: https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-logging-auditing.html#session-manager-logging-auditing-s3

A bucket needs to be setup with encryption enabled to receive the SSM session logs.  This bucket name is used in the EC2 instance role and SSM Session document.

# SSM with run-as

## Users
Will have two shared users.  Can we still answer the 5 Ws?

### user-sudo
This user can sudo.

What happened?
* SSM has full interactive session capture
* Will be able to get a log of everything this user did

Where did it take place?
* Via SSM the user will be using Okta which is tied to a unique account
* CloudTrail should be tell us which machine this user login to

When did it occur?
* Logs from SSM session capture has a time stamp
* Logs from the EC2 machines has the timestamp on when the shared user did something

Why did it happen?
* With full session recording we can see what caused something
* The EC2 logs will also tell us why something happened

Who was involved?
* The SSM session is tied to a unique Okta account

### user-no-sudo
This user has not sudo abilities.

The 5ws are the same as the `user-sudo` answers

# Discussions/caveats

## No unique users on the EC2 machine?
That is correct.  A user will be uniquely identified via SSM but when SSM places the user onto an EC2 instance, it will assume a shared user.  This is a limitation of the SSM feature set.  However, we are still able to answer the 5 Ws accurately.  SSM will uniquely identify the person on session start.  It will also capture the entire interactive SSH session.  By using this information, we can see exactly what the user was doing.  We can also "pretty" closely tie it back to the EC2 Linux logs on what happened and who was responsible.

Since we have the full capture, we can say we have a compensating control for the shared login on the machine and thus have accountability.

## EC2 Instance needs ssm-agent installed
Any EC2 instance that wants to participate in this setup, needs to have the AWS ssm-agent installed on it.  This is a prerequisite for this setup.

Prerequisites: https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-prerequisites.html

## Should not use `aws ssm start-session` on a shared machine
You probably should not use the `aws ssm start-session` to connect to a remote machine on a shared machine.  The AWS temporary token value shows up in the `ps` list:

```
ps aux | grep ssm
g44      1322389  0.0  0.0   2716   524 pts/3    S+   20:49   0:00 aws ssm start-session --target i-0efbd22c010b703bf --document-name SSM-gar-test-sudoer
g44      1322390  0.3  0.1 141432 47940 pts/3    S+   20:49   0:00 aws ssm start-session --target i-0efbd22c010b703bf --document-name SSM-gar-test-sudoer
g44      1322395  0.3  0.0 856848 11916 pts/3    Sl+  20:49   0:00 session-manager-plugin {"SessionId": "garland.kan-0191f0eae08e1b4f8", "TokenValue": "AAEAAbgY78NB2V5KlbYS3hpjegONznprdtIhAYhfZfWRp+zTAAAAAF6+EUjaUDZXp05OWxxhFMOChSpVAlbUiV5ozjiztSzhRUpyzUVLL9XjlcW5FEKumgt1/uzq2HSFG2jF31GoCqRKQcKhlDMdu2vKHRLsJ7jxT5M51Mmoo2EQKQ2DggJ6oz++byhQyh6osqZjH9SBme+eSkCkQLTvG+P7/i+DblvCOBwWFWooS1jfRqS4jai3+7jsd/eFncLVrdWFwDwND8cltwoW4bMVIML97eZ8x4Sraq1ioCJ0EtZ//TcIWiJ/I7jGMG7LsjB1ipI57Axd7hRbGaKtAIOv9JlF4Io43OeKhzd1DI3NFg==", "StreamUrl": "wss://ssmmessages.us-east-1.amazonaws.com/v1/data-channel/garland.kan-0191f0eae08e1b4f8?role=publish_subscribe", "ResponseMetadata": {"RequestId": "1cf7099e-1fdf-47f6-9cdb-101eab7abddf", "HTTPStatusCode": 200, "HTTPHeaders": {"x-amzn-requestid": "1cf7099e-1fdf-47f6-9cdb-101eab7abddf", "content-type": "application/x-amz-json-1.1", "content-length": "610", "date": "Fri, 15 May 2020 03:49:27 GMT"}, "RetryAttempts": 0}} us-east-1 StartSession  {"Target": "i-0efbd22c010b703bf", "DocumentName": "SSM-gar-test-sudoer"} https://ssm.us-east-1.amazonaws.com
```

## Where do I view Session Manager's activities

### User login sessions
You can view session login activities in `CloudTrails`.

Go to:
* AWS Console -> CloudTrails -> Event History
* Filter by Event name: `StartSession`

This will list all of the sessions that were started.  Here is an example of the event:
```json
{
    "eventVersion": "1.05",
    "userIdentity": {
        "type": "IAMUser",
        "principalId": "AIDAVE4W5C6YOXXF5XPOR",
        "arn": "arn:aws:iam::354114410416:user/garland.kan.temp",
        "accountId": "354114410416",
        "accessKeyId": "AKIAVE4W5C6YJPLGCFU5",
        "userName": "garland.kan.temp"
    },
    "eventTime": "2020-05-18T17:00:24Z",
    "eventSource": "ssm.amazonaws.com",
    "eventName": "StartSession",
    "awsRegion": "us-east-1",
    "sourceIPAddress": "38.30.8.138",
    "userAgent": "aws-cli/2.0.0 Python/3.7.3 Linux/5.4.0-29-generic botocore/2.0.0dev4",
    "requestParameters": {
        "target": "i-02311671588e96626",
        "documentName": "SSM-sudo"
    },
    "responseElements": {
        "sessionId": "garland.kan.temp-0e34861185201706f",
        "tokenValue": "Value hidden due to security reasons.",
        "streamUrl": "wss://ssmmessages.us-east-1.amazonaws.com/v1/data-channel/garland.kan.temp-0e34861185201706f?role=publish_subscribe"
    },
    "requestID": "35714caa-4b64-47c1-9842-2dc6d4786070",
    "eventID": "4b7a66fc-bffb-4179-be64-69bba2bf714c",
    "readOnly": false,
    "eventType": "AwsApiCall",
    "recipientAccountId": "354114410416"
}
```

## How do I troubleshoot the SSM Agent?
The SSM Agent runs on each EC2 node that wants to participate in the SSM interactive session setup.  This agent has IAM permissions via the instance role we created to talk to the AWS SSM API (vpc endpoint) that we created.  When someone initiates a session from the console or the CLI, there is an API call to the AWS SSM API and SSM performs authentication and authorization at this point.  If that succeeds, AWS SSM contacts the requested EC2 instance via the AWS SSM Agent that is running on it.  If the SSM agent on the EC2 machine answers, a connection will be created with the appropriate settings via the SSM Document (either the default or a custom document).

### Where are the SSM Agents logs?
Doc: https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-agent-logs.html
* `/var/log/amazon/ssm/amazon-ssm-agent.log`
* `/var/log/amazon/ssm/errors.log`

The Session log:
* Has the session id: `garland.kan.temp-0073b0a9869ded8de`.  This can be used to tie it back to the CloudTrail logs
```
Script started on 2020-05-27 23:00:48+0000
[?1034hsh-4.2# /usr/bin/ssm-session-logger /var/lib/amazon/ssm/i-0c76bc102a2c8324b/sess 
ion/orchestration/garland.kan.temp-0073b0a9869ded8de/Standard_Stream/ipcTempFile 
.log false
Error occurred fetching the seelog config file path:  open /etc/amazon/ssm/seelog.xml: no such file or directory
Initializing new seelog logger
New Seelog Logger Creation Complete
[?1034hsh-4.2$ 
[Ksh-4.2$ 

sh-4.2$ 

sh-4.2$ 

sh-4.2$ # test 1

sh-4.2$ ls /

bin  boot  dev	etc  home  lib	lib64  local  media  mnt  opt  proc  root  run	sbin  srv  sys	tmp  usr  var

sh-4.2$ exit

exit

sh-4.2# exit
exit

Script done on 2020-05-27 23:01:53+0000
```

#### Not writing session logs to the S3 bucket
The EC2 instance needs access to the bucket.  In the `/var/log/amazon/ssm/errors.log` logs on the EC2 instance you might see logs like this which is an indication that the node does not have access to S3:

```
2020-05-26 18:11:59 ERROR [S3Upload @ s3util.go.114] [ssm-session-worker] [garland.kan.temp-075bd0a4981d0a426] [DataBackend] [pluginName=Standard_Stream] Failed uploading /var/lib/amazon/ssm/i-0be867147d0c364b8/session/orchestration/garland.kan.temp-075bd0a4981d0a426/Standard_Stream/garland.kan.temp-075bd0a4981d0a426.log to s3://expanse-ssm-session-logs-dev/dev/garland.kan.temp-075bd0a4981d0a426.log err:AccessDenied: Access Denied
```

You can give the EC2 instance access to the bucket by giving attaching a policy to the instance role:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::expanse-ssm-session-logs-dev",
                "arn:aws:s3:::expanse-ssm-session-logs-dev/*"
            ]
        }
    ]
}
```

### Enabling debug on the SSM Agent
Doc: https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-agent-logs.html#ssm-agent-debug-log-files


# Testing

## Login as both classes of user

### Users in the sudoers class can login with the sudoers user


### Users in the non sudoers class can login


### Users in the non sudoers class can NOT login as the sudoer's user


## Answering the 5 Ws

### What happened?
Can we get the SSM interactive session logs?

Does it tell us who the user is?

### Where did it take place?
Does it tell us which machine this all took place on?

### When did it occur?
Timestamps?

### Why did it happen?
The sequence of activities?

### Who was involved?
Who was the unique user involved?


# Usage

## Requirements

### aws cli
If using the CLI, you need the `aws cli`

Install doc: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html

### session manager plugin
If you want to use the AWS CLI to start and end sessions that connect you to your managed instances, you must first install the Session Manager plugin on your local machine. The plugin can be installed on supported versions of Microsoft Windows, macOS, Linux, and Ubuntu Server. 

Install doc: https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html

## starting a session

```
aws ssm start-session --target i-0061375d1e98e81fc --document-name SSM-sudo
```

# Tunnelling
https://aws.amazon.com/blogs/aws/new-port-forwarding-using-aws-system-manager-sessions-manager/

```
aws ssm start-session --target $INSTANCE_ID \
--document-name AWS-StartPortForwardingSession \
--parameters '{"portNumber":["80"],"localPortNumber":["9999"]}'
```
