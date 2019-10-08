ECK - Elastic Cloud on Kubernetes
================================

An operator to run Elasticsearch on Kubernetes


Source: https://github.com/elastic/cloud-on-k8s

Quick start guide: https://www.elastic.co/guide/en/cloud-on-k8s/current/index.html

Example configs: https://github.com/elastic/cloud-on-k8s/tree/0.9/operators/config/samples

# Install


```
kubectl apply -f all-in-one.yaml
```

Work around for the timeout issue: https://github.com/elastic/cloud-on-k8s/issues/896#issuecomment-494346828
```
kubectl delete ValidatingWebhookConfiguration validating-webhook-configuration
```

```
kubectl apply -f elasticsearch-cluster.yaml
```


Get cluster info:
```
kubectl -n elasticsearch get elasticsearch
```

## Node affinity settings

https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-advanced-node-scheduling.html

## Get Password

User: elastic

Get password:
```
kubectl -n elasticsearch get secret elasticsearch-cluster-es-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode
```

## Port-forward to kibana

```
kubectl -n elasticsearch port-forward service/elasticsearch-cluster-kb-http 5601
```

In your browser, go to:  https://localhost:5601

## Port-forward to Elasticsearch

```
kubectl -n elasticsearch port-forward service/elasticsearch-cluster-es-http 9200
```

# Not supporting nginx-ingress

It seems they don't want to support nginx ingress and have removed the ingress
resource example:  https://github.com/elastic/cloud-on-k8s/pull/806


# Flowlog use case

Flowlogs goes to S3

Logstash reads from S3 and push to Elasticsearch

# Logstash S3 plugin

https://www.elastic.co/guide/en/logstash/current/plugins-inputs-s3.html

Github:  https://github.com/logstash-plugins/logstash-input-s3
Github https://github.com/elastic/logstash

Permission needed for the S3 bucket:  https://github.com/logstash-plugins/logstash-input-s3#required-s3-permissions

Logstash container: https://www.elastic.co/guide/en/logstash/current/docker.html

Installing plugins: https://www.elastic.co/guide/en/logstash/current/working-with-plugins.html

Logstash container configuration: https://www.elastic.co/guide/en/logstash/current/docker-config.html

## AWS Flowlog format

```
version account-id interface-id srcaddr dstaddr srcport dstport protocol packets bytes start end action log-status
2 227450484680 eni-00042ec487c70cda5 172.17.51.218 172.17.50.144 45445 3999 6 6 354 1565395407 1565395419 ACCEPT OK
```

## Starting Logstash container locally for testing

Export out AWS Authentication variables
```
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
export AWS_DEFAULT_REGION=us-east-1
export S3_BUCKET=<bucket name where the flowlogs are stored
```

Set Elasticsarch endpoint:
```
export ELASTICSEARCH_ENDPOINT=http://34.67.98.186:80
export ELASTICSEARCH_USERNAME=elastic
export ELASTICSEARCH_PASSWORD=password-here
export ELASTICSEARCH_INDEX_NAME_PREFIX=my-index8
```

Build and run
```
docker build -t garland/logstash-input-s3:dev .
docker run --rm -it --net=host -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} -e AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION} -e S3_BUCKET=${S3_BUCKET} -e ELASTICSEARCH_ENDPOINT=${ELASTICSEARCH_ENDPOINT} -e ELASTICSEARCH_USERNAME=${ELASTICSEARCH_USERNAME} -e ELASTICSEARCH_PASSWORD=${ELASTICSEARCH_PASSWORD} -e ELASTICSEARCH_INDEX_NAME_PREFIX=${ELASTICSEARCH_INDEX_NAME_PREFIX} -v $PWD/logstash.conf:/usr/share/logstash/pipeline/logstash.conf garland/logstash-input-s3:dev
```

Pipeline path:

```
logstash <---> Internet <---> ELB <----> Nginx Ingress <----> ES Service <---> ES
```

## Filters

https://www.elastic.co/guide/en/logstash/7.x/plugins-filters-dissect.html

https://www.elastic.co/guide/en/logstash/current/plugins-filters-grok.html

## Queries

```
{
  "query": {
    "regexp": {
      "srcaddr": {
        "value": "172.*",
        "flags": "ALL"
      }
    }
  }
}
```


6/21 - 1561152573
8/9 - 1533772800

Searching for items 8/9 and after
```
{
  "query": {
    "regexp": {      
      "start": {
        "value": "153377.*",
        "flags": "ALL"
      }
    }
  }
}
```

# Cloud

## Azure

Flowlogs example:  https://logz.io/blog/azure-nsg-elk/

# Dashboards

Ideas for dashboard items

Visualization docs: https://www.elastic.co/guide/en/kibana/current/tutorial-visualizing.html

Aggregation doc: https://qbox.io/blog/elasticsearch-aggregations

## Source address from external IP address

Will answer:

What external IP addresses are making connections to our nodes in our VPC?

Not:
```
{
  "query": {
    "regexp": {
      "srcaddr": {
        "value": "172.*",
        "flags": "ALL"
      }
    }
  }
}
```

## Destination port 22

Will answer:

What SSH connections are being used and to where

Not:
```
{
  "query": {
    "regexp": {
      "srcaddr": {
        "value": "172.*",
        "flags": "ALL"
      }
    }
  }
}
```

```
{
  "query": {
    "regexp": {
      "dstport": {
        "value": "22",
        "flags": "ALL"
      }
    }
  }
}
```


## Destination port to common database ports

Will answer:

What connections are made to common database ports

* MySQL - 3306
* Postgres -
* MongoDB
* Redis

## Biggest data movers
Will answer:

What has transferred the most data

What connections has transferred the most data

## Protocol number pie chart

A pie chart showing the breakout of percentage of all the protocol numbers


## Action Accept/Reject pie chart

A pie chart showing the breakout of the Accepted packets versus the Rejected packets

## Direction of transferred pie chart

A pie chart showing the percentage of inbound versus outbound transfer
