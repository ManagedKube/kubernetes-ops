# eks

Builds and EKS cluster using this module: https://github.com/terraform-aws-modules/terraform-aws-eks

## AWS CLI Authentication

### Setup your local SSO AWS CLI Profile
Doc: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-sso.html

This will startup the config walk through
```
aws configure sso
```

Config params:
* The start URL: https://d-90676a13de.awsapps.com/start
* CLI profile name: `gem-dev`
  * name it something simple

Set your env to use this profile:
```
export AWS_PROFILE=gem-dev
```

Now you can run any AWS CLI commands and it will use this profile as the authentication mechanism.

## Subsequent AWS CLI Login

```
aws sso login --profile gem-dev
```

## Post cluster creation

list clusters
```
aws eks --region us-east-1 list-clusters
```

Get kubeconfig
```
aws eks --region us-east-1 update-kubeconfig --name dev --profile gem-dev
```
