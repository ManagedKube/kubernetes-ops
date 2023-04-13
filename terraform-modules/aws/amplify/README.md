# AWS Amplify App Terraform Module

This Terraform module provisions an AWS Amplify App with customizable inputs.

## Usage

  name                      = The name of the Amplify App
  repository_url            = The URL of the Git repository for the Amplify App
  enable_branch_auto_build  = Enable branch auto-build for the Amplify App
  build_spec                = Build spec for the Amplify App
  custom_rules              = Custom rules for the AWS Amplify App
  environment_variables     = Environment variables for the Amplify App
  oauth_token               = GitHub access token for the Amplify App
  branches_to_deploy	    = List of branches to deploy with AWS Amplify


## Outputs
    Name	                            Description
    amplify_app_id	            The ID of the created Amplify App
    amplify_app_arn	            The ARN of the created Amplify App
    amplify_app_name	        The name of the created Amplify App
    amplify_app_default_domain	The default domain of the created Amplify App


This `README.md` file provides an overview of your Terraform module, including its usage, inputs, and outputs. You can modify this file to include additional information or instructions as needed.
