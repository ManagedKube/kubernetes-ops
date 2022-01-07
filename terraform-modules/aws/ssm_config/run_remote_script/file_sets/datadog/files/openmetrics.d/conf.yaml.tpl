## All options defined here are available to all instances.
#
init_config:

    ## @param proxy - mapping - optional
    ## Set HTTP or HTTPS proxies for all instances. Use the `no_proxy` list
    ## to specify hosts that must bypass proxies.
    ##
    ## The SOCKS protocol is also supported like so:
    ##
    ##   socks5://user:pass@host:port
    ##
    ## Using the scheme `socks5` causes the DNS resolution to happen on the
    ## client, rather than on the proxy server. This is in line with `curl`,
    ## which uses the scheme to decide whether to do the DNS resolution on
    ## the client or proxy. If you want to resolve the domains on the proxy
    ## server, use `socks5h` as the scheme.
    #
    # proxy:
    #   http: http://<PROXY_SERVER_FOR_HTTP>:<PORT>
    #   https: https://<PROXY_SERVER_FOR_HTTPS>:<PORT>
    #   no_proxy:
    #   - <HOSTNAME_1>
    #   - <HOSTNAME_2>

    ## @param skip_proxy - boolean - optional - default: false
    ## If set to `true`, this makes the check bypass any proxy
    ## settings enabled and attempt to reach services directly.
    #
    # skip_proxy: false

    ## @param timeout - number - optional - default: 10
    ## The timeout for connecting to services.
    #
    # timeout: 10

    ## @param service - string - optional
    ## Attach the tag `service:<SERVICE>` to every metric, event, and service check emitted by this integration.
    ##
    ## Additionally, this sets the default `service` for every log source.
    #
    # service: <SERVICE>

## Every instance is scheduled independent of the others.
#
instances:

    ## @param prometheus_url - string - required
    ## The URL where your application metrics are exposed by Prometheus.
    #
  - prometheus_url: ${prometheus_url}

    ## @param namespace - string - required
    ## The namespace to be prepended to all metrics.
    #
    namespace: ${namespace}

    ## @param metrics - (list of string or mapping) - required
    ## List of metrics to be fetched from the prometheus endpoint, if there's a
    ## value it'll be renamed. This list should contain at least one metric.
    #
    metrics:
      - processor:cpu
      - memory:mem
      - io
      - prometheus*
      - net*
      - go*