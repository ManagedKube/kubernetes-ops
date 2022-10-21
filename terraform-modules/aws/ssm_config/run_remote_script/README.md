# SSM Run Remote Script

## What does this do?
This will:
* Push one of the `file_sets` folder and all sub files/folders to an S3 bucket
* Create an AWS SSM association that targets a set of nodes via EC2 tags
* This "association" will run the script on these set of nodes

Prerequisites:
* Create an S3 bucket that the `file_sets` will use

## Troubleshooting

### To view when there was a run
Navigate to the AWS console:
* AWS System Manager -> Node Management -> Run command
* Click on the Command History tab

This list all of the runs.

If you just updated the run information, it would trigger almost instantaniously.

### Viewing runs and log outputs on the node
The location where the files are placed onto the node is with this var `upload_working_dir`.  The default location is `/tmp/ssm-configs`.


## Run script from S3

* https://docs.aws.amazon.com/systems-manager/latest/userguide/integration-s3-shell.html

```
{"path":"https://s3.amazonaws.com/garland-1234-ssm-test/run.sh"}
```


## Script from Github
NOTE: This doesnt work with our repo (explanation below)

* https://aws.amazon.com/blogs/mt/run-scripts-stored-in-private-or-public-github-repositories-using-amazon-ec2-systems-manager/
* https://docs.aws.amazon.com/systems-manager/latest/userguide/integration-github-python.html


SSM Document name: `AWS-RunRemoteScript`

```
{
    "owner": "owner_name",
    "repository": "repository_name",
    "getOptions": "branch:branch_name",
    "path": "path_to_document",
    "tokenInfo": "{{ssm-secure:SecureString_parameter_name}}"
}
```

```
aws ssm put-parameter --name test-token --value xxxxxxx --type SecureString
```




{
    "owner": "marqeta",
    "repository": "featurespace-onprem-infra",
    "getOptions": "branch:gkan.RP-2585-node-list-ssm-run-command",
    "path": "/terraform-modules/aws/ssm/run_remote_script/scripts/run.sh",
    "tokenInfo": "{{ssm-secure:test-token}}"
}

AWS SSM outputs the runtime error:
```
GET https://api.github.com/repos/marqeta/featurespace-onprem-infra/contents//terraform-modules/aws/ssm/run_remote_script/scripts/run.sh?ref=gkan.RP-2585-node-list-ssm-run-command: 401 Bad credentials []
```

We have a self hosted repository at: https://github.marqeta.com/marqeta/featurespace-onprem-infra.  AWS SSM is going to the public `api.github.com`
host.  There is no configuration option to change the host where AWS SSM should reach the Github server.  Which means we will not be able
to auth correctly and even if it did, the repository isn't hosted on the public Github.com servers.

