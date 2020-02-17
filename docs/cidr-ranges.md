CIDR Ranges
=====================

# IP Calculator
Here is a very good online IP CIDR calculator

http://www.subnet-calculator.com/cidr.php


# Global

| Name                              | CIDR          |
|-----------------------------------|---------------|
| docker0                           | 172.26.0.0/16 |
| Kubernetes aws - dev-example      | 10.9.0.0/16   |
| Kubernetes aws - dev              | 10.10.0.0/16  |
| Kubernetes aws - qa               | 10.11.0.0/16  |
| Kubernetes aws - staging          | 10.12.0.0/16  |
| Kubernetes aws - prod             | 10.13.0.0/16  |
| Kubernetes aws - ....             | 10.13.0.0/16  |
| Kubernetes gcp - dev              | 10.20.0.0/16  |
| Kubernetes gcp - qa               | 10.21.0.0/16  |
| Kubernetes gcp - staging          | 10.22.0.0/16  |
| Kubernetes gcp - prod             | 10.23.0.0/16  |

## Reserved ranged for each environment
Each envrionment has a bunch of initial reserved ranges to bring up the entire
application.  The following defines these ranges in a generic sense that can
be applied to any of the above CIDRs.

## Kops
| Name             | CIDR         | Address Range |
|------------------|--------------|---------------|
| xxx              | 10.xx.0.0/16 | xxxxx - xxxxx |

## AWS Services Subnets
| Name                                  | CIDR             | Address Range               |
|---------------------------------------|------------------|-----------------------------|
| RDS  - subnet 1                       | 10.xx.100.0/28   | 10.xx.100.0  - 10.xx.100.15 |
| RDS  - subnet 2                       | 10.xx.100.16/28  | 10.xx.100.16 - 10.xx.100.31 |
| Redshift subnet 1                     | 10.xx.100.32/28  | 10.xx.100.32 - 10.xx.100.47 |
| Redshift subnet 2                     | 10.xx.100.48/28  | 10.xx.100.48 - 10.xx.100.63 |
| app one - subnet 1                    | 10.xx.100.64/28  | 10.xx.100.64 - 10.xx.100.79 |
| app one - subnet 2                    | 10.xx.100.64/28  | 10.xx.100.64 - 10.xx.100.79 |
| app two - subnet 1                    | 10.xx.100.64/28  | 10.xx.100.64 - 10.xx.100.79 |
| app two - subnet 2                    | 10.xx.100.64/28  | 10.xx.100.64 - 10.xx.100.79 |

## GCP Subnets
| Name                                  | CIDR             | Address Range               |
|---------------------------------------|------------------|-----------------------------|
| VPC - default public subnet           | 10.xx.10.0/24    | 10.xx.10.0  - 10.xx.10.255  |
| VPC - default private subnet          | 10.xx.20.0/24    | 10.xx.20.0 - 10.xx.20.255   |
| GKE cluster public subnet             | 10.xx.11.0/24    | 10.xx.11.0 - 10.xx.11.255   |
| GKE cluster private subnet            | 10.xx.21.0/24    | 10.xx.21.0 - 10.xx.21.255   |
| GKE master CIDR block                 | 10.xx.22.0/28    | 10.xx.22.0 - 10.xx.22.15    |
| GKE pod CIDR range                    | 10.xx.64.0/19    | 10.xx.64.0 - 10.xx.95.255   |
| GKE service CIDR range                | 10.xx.96.0/19    | 10.xx.96.0 - 10.xx.127.255  |
| Transit Gateway - subnet1             | 10.xx.104.16/28  | 10.xx.104.16 - 10.xx.104.31 |
| Transit Gateway - subnet2             | 10.xx.104.32/28  | 10.xx.104.32 - 10.xx.104.47 |
| Transit Gateway - subnet3             | 10.xx.104.48/28  | 10.xx.104.48 - 10.xx.104.63 |