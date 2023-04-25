# AWS Amplify App Terraform Module

This Terraform module provisions an AWS Amplify App with customizable inputs.

## Usage

  name                      = The name of the Amplify App
  repository_url            = The URL of the Git repository for the Amplify App
  build_spec                = Build spec for the Amplify App
  custom_rules              = Custom rules for the AWS Amplify App
  environment_variables     = Environment variables for the Amplify App
  gh_access_token           = GitHub access token for the Amplify App
  branch_name               = The branch to be deployed
  domain_name               = The domain name to associate with the app
  sub_domain_prefix         = The subdomain prefix for the domain association
  sub_domain_branch         = The branch to associate with the subdomain


## Outputs
    Name	                            Description
    amplify_app_id	            The ID of the created Amplify App
    amplify_app_arn	            The ARN of the created Amplify App
    amplify_app_name	        The name of the created Amplify App
    amplify_app_default_domain	The default domain of the created Amplify App


This `README.md` file provides an overview of your Terraform module, including its usage, inputs, and outputs. You can modify this file to include additional information or instructions as needed.
