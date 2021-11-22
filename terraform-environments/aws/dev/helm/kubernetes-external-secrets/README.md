# Kubernetes-external-secrets


## Creating a secret

String:
```
aws secretsmanager create-secret --name myapp/password --secret-string "1234"
aws secretsmanager create-secret --name myapp/some-key --secret-string "5678"
```

Binary file:
```
aws secretsmanager create-secret --name myapp-dev/file1 --secret-binary fileb://~/Downloads/Testing_MATCH_API-sandbox.p12
```


## Using the secret

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
  - name: mypod
    image: redis
    volumeMounts:
    - name: foo
      mountPath: "/etc/foo"
      readOnly: true
  volumes:
  - name: foo
    secret:
      secretName: mysecret
```

The secret will be mounted into `/etc/foo`

