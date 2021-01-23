AWS SSM Document for Sessions
==============================
These SSM Documents provides configurations for an SSM session

Main docs: https://docs.aws.amazon.com/systems-manager/latest/userguide/getting-started-sessiondocumentaccesscheck.html

The purpose of this document is to provide configuration for an SSM interactive session.  You can force a user to use a particular document which can force them to run as a certain user on the end host.  Then if this user on the end host does not have sudo access this, mean this user will not have sudo access either.

Example SSM Document:
```json
{
  "schemaVersion": "1.0",
  "description": "Document to hold regional settings for Session Manager",
  "sessionType": "Standard_Stream",
  "inputs": {
    "s3BucketName": "expanse-ssm-session-logs-dev",
    "s3KeyPrefix": "dev",
    "s3EncryptionEnabled": false,
    "cloudWatchLogGroupName": "",
    "cloudWatchEncryptionEnabled": true,
    "kmsKeyId": "",
    "runAsEnabled": true,
    "runAsDefaultUser": "user-sudo"
  }
}
```

# Setting `s3EncryptionEnabled` to `false
When we created our S3 bucket for the log output, we enabled encryption on it.  Anything placed in here will be encrypted.

https://aws.amazon.com/premiumsupport/knowledge-center/bucket-policy-encryption-s3/

This is set to `false` since we are not using the `kms` key for encryption and just the S3 default key.

# Restricting the commands a user can run
Doc: https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-restrict-command-access.html

This allows you to restrict the commands a user can run.
* Setup one or more SSM Session Document that defines what commands are allowed
* Associate these documents to the user's IAM
* User will use this document name when running an interactive command
