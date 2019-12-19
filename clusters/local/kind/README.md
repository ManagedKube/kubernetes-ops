Kind
=======
Kind is an open source project that brings up a local Kuberenetes environment all
running in Docker.

Doc: https://kind.sigs.k8s.io/docs/user/quick-start/


# Installation instructions:

Doc: https://github.com/kubernetes-sigs/kind#installation-and-usage


# Usage:

## Creation:
```
kind create cluster --config config.yaml --image kindest/node:v1.13.12
```

## List
```
kind get clusters
```

## Delete
```
kind delete cluster
```

## Debug
By defaul if the create command fails it will clean up the Docker containers.

You can append the `--retain` flag in the `kind create cluster...` command so 
it won't remove the Docker containers on failure and you can debug the containers
from there.

There is also a verbose flag to give you more information on what it is doing: `--v 7`

# Example deployment

## nginx-ingress

```
cd kubernetes/helm/nginx-ingress/
```

Deploy:
```
make ENVIRONMENT=kind external-apply
```

## http-echo app

```
cd kubernetes/helm/http-echo
```

Deploy:
```
kubectl apply -f namespace.yaml
kubectl -n http-echo apply -f .
```

Test out the ingress:
```bash
root@ip-10-4-2-98:/home/ubuntu/kubernetes-ops/kubernetes/helm/http-echo# curl -v http://localhost -H "HOST: gar1.example.com"
* Rebuilt URL to: http://localhost/
*   Trying 127.0.0.1...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 80 (#0)
> GET / HTTP/1.1
> HOST: gar1.example.com
> User-Agent: curl/7.58.0
> Accept: */*
> 
< HTTP/1.1 200 OK
< Server: nginx/1.15.10
< Date: Thu, 19 Dec 2019 20:28:46 GMT
< Content-Type: text/plain
< Transfer-Encoding: chunked
< Connection: keep-alive
< Vary: Accept-Encoding
< 


Hostname: echoserver-6bdccfbcd4-jv557

Pod Information:
	-no pod information available-

Server values:
	server_version=nginx: 1.13.3 - lua: 10008

Request Information:
	client_address=10.244.1.17
	method=GET
	real path=/
	query=
	request_version=1.1
	request_scheme=http
	request_uri=http://gar1.example.com:8080/

Request Headers:
	accept=*/*
	host=gar1.example.com
	user-agent=curl/7.58.0
	x-forwarded-for=10.244.1.1
	x-forwarded-host=gar1.example.com
	x-forwarded-port=80
	x-forwarded-proto=http
	x-original-uri=/
	x-real-ip=10.244.1.1
	x-request-id=2052b9f9e6a91587c5810773352fe7ab
	x-scheme=http

Request Body:
	-no body in request-

* Connection #0 to host localhost left intact
```