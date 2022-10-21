# Generate Cert

Source: https://github.com/gruntwork-io/private-tls-cert

This repository contains a Terraform module that can be used to generate self-signed TLS certificate. To be more accurate, the module generates the following:

* A Certificate Authority (CA) public key
* The public and private keys of a TLS certificate signed by the CA
