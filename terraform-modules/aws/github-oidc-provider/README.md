# Github OIDC Provider

This module setups an AWS OIDC Identity prodiver for Github Actions.  This will allow you to use OIDC Federation to give your
Github Actions access to your AWS account.

Main Doc: https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services

## Filtering on the `sub`
Conditions to validate

Doc: https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect#examples

This controls can help you do things like:
* Only allow a certain branch
* Only allow a certain repo/org
