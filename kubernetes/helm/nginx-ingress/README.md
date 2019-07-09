nginx-ingress
===============

Source helm chart:  https://github.com/helm/charts/tree/master/stable/nginx-ingress

# Topology this creates

![Alt text](./diagrams/nginx-ingress-diagram.svg)

# Usage:

## internal

### template
```
make ENVIRONMENT=dev internal-template
```

### apply
```
make ENVIRONMENT=dev internal-apply
```

### delete
```
make ENVIRONMENT=dev internal-delete
```

## external

### template
```
make ENVIRONMENT=dev external-template
```

### apply
```
make ENVIRONMENT=dev external-apply
```

### delete
```
make ENVIRONMENT=dev external-delete
```
