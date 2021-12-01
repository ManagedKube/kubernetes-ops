# Route53 Hosted Zone with DNSSEC

You can verify the DNSSEC here after applying: https://dnssec-analyzer.verisignlabs.com

## Provider
This module does not contain a provider and leaves it up to the instantiator to add this section into their Terraform.  The reason is to keep this module reusable because you might have different provider settings than what this module would set and you can not have more than one of these in a Terraform run.

You should add a section like this to your terraform instantiation:
```
# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}
```

Setting the region to `us-east-1` is the eaiest thing to do beause it seems that AWS sets the route53 hosted region to this region and the signing keys for DNSSEC has to be in the same region.
