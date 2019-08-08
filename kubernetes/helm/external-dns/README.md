external-dns
==============

Source: https://github.com/helm/charts/tree/master/stable/external-dns


# IAM Permissions needed for this app:
https://github.com/helm/charts/tree/master/stable/external-dns#iam-permissions

You can create an AWS key specifically for this application with these permissions

```
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Effect": "Allow",
     "Action": [
       "route53:ChangeResourceRecordSets"
     ],
     "Resource": [
       "arn:aws:route53:::hostedzone/*"
     ]
   },
   {
     "Effect": "Allow",
     "Action": [
       "route53:ListHostedZones",
       "route53:ListResourceRecordSets"
     ],
     "Resource": [
       "*"
     ]
   }
 ]
}
```

# Annotating the service or ingress

```
external-dns.alpha.kubernetes.io/hostname: nginx.example.org
```
