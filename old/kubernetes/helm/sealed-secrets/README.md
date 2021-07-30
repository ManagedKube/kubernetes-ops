sealed-secrets
===============

Source: https://github.com/bitnami-labs/sealed-secrets

# Getting the pub key

```
kubeseal --fetch-cert \
--controller-namespace=sealed-secrets \
--controller-name=sealed-secrets \
> pub-cert.pem
```
Doesnt seem to work on a GKE cluster


# Creating a secret

```
# Secret source information
NAMESPACE=external-dns
SECRET_NAME=gcp-credentials-json
FILE_PATH=/media/veracrypt1/managedkube/sa-managedkube-admin.json

# kubeseal info
PUB_CERT=./kubernetes/helm/sealed-secrets/environments/gcp-dev/pub-cert.pem
KUBESEAL_SECRET_OUTPUT_FILE=${SECRET_NAME}.yaml

kubectl -n ${NAMESPACE} create secret generic ${SECRET_NAME} \
--from-file=${FILE_PATH} \
--dry-run \
-o json > ${SECRET_NAME}.json

kubeseal --format=yaml --cert=${PUB_CERT} < ${SECRET_NAME}.json > ${KUBESEAL_SECRET_OUTPUT_FILE}
```

# Backup and restore of the private key

https://github.com/bitnami-labs/sealed-secrets#how-can-i-do-a-backup-of-my-sealedsecrets

```
kubectl get secret -n sealed-secrets -l sealedsecrets.bitnami.com/sealed-secrets-key -o yaml >master.key
```

This key file should be kept in a safe place
