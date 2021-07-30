restrict-by-ssm-document
========================

This module creates an IAM policy that allows a user to reach all EC2 hosts but restricts the user to a specific SSM Session document.

When an IAM user or group is assigned this policy the user will have SSM interactive session access and they will have to use the SSM session document specified by the `document_name` variable.  

This can allow you to control:
* What EC2 user name the user will login as on the machine and in turn you can control the access of this particular user
* Force that the entire interactive shell session is recorded and put into S3
