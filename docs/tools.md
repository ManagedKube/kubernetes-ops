Tools you will need
====================

# Download CLIs
This project uses various CLIs and tools to help create this infrastructure.

## Terraform

Download location: https://releases.hashicorp.com/terraform/

## Terragrunt

Download location: https://github.com/gruntwork-io/terragrunt/releases/tag/v0.18.7

## AWS CLI
Any recent version of the aws cli should work.  The version it was tested on
was:

```
aws-cli/1.16.xx
```

Install instructions:  https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html

## sshuttle
`sshuttle` is a tool that will create an SSH tunnel from your local laptop
to a remote network and forward everything destined for that IP space over there
with DNS resolution.  It uses ssh to create the tunnel.  

Why not just use SSH?  SSH does not have the functionality to forward the entire
CIDR range of the remote network to your local machine.  The alternative is to
forward each individual host to your local machine and even in this case, you
don't get DNS resolution of the remote network with it.

OSX
```
brew install sshuttle
```

Linux install instructions: https://github.com/sshuttle/sshuttle#obtaining-sshuttle
