## Why I might use ip set?
An IP set is a feature provided by AWS Web Application Firewall (WAF) that allows you
to define a collection of IP addresses or IP ranges (in CIDR notation) that you want
to allow or block from accessing your web applications or APIs.

There are several reasons why you might want to use an IP set:

1. Security: By using an IP set, you can restrict access to your applications to a
specific set of IP addresses. This helps to prevent unauthorized access, block
malicious traffic, and protect your resources from various types of attacks, such as
DDoS attacks or brute-force attempts.

2. Whitelisting/Blacklisting: An IP set allows you to create a whitelist or
blacklist of IP addresses. With a whitelist, you can specify the IP addresses that
are allowed to access your application, blocking all others. Conversely, with a
blacklist, you can specify the IP addresses that are not allowed, while allowing all
other addresses.

3. Geo-blocking: If you want to restrict access to your application based on
geographic locations, an IP set can help. You can define IP ranges associated with
specific countries or regions, allowing or blocking access based on those regions.
This can be useful for compliance purposes or to prevent traffic from high-risk
regions.

4. Dynamic Updates: IP sets can be dynamically updated, allowing you to add or
remove IP addresses as needed. This flexibility enables you to respond quickly to
changing security requirements, such as adding new trusted IP addresses or blocking
malicious sources.

5. Integration with AWS WAF Rules: IP sets can be used in conjunction with other AWS
WAF features, such as rules and conditions, to create more sophisticated access
control policies. You can combine IP sets with rules to define complex logic for
allowing or blocking traffic based on IP addresses, user agents, request headers, or
other criteria.

By leveraging AWS WAF's IP set feature, you can enhance the security of your web
applications and APIs by controlling access at the IP address level. It provides a
flexible and scalable mechanism to define and manage your desired IP address-based
access control policies.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_wafv2_ip_set.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_ip_set) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ip_address_version"></a> [ip\_address\_version](#input\_ip\_address\_version) | (Required) Specify IPV4 or IPV6. Valid values are IPV4 or IPV6. | `string` | `"IPV4"` | no |
| <a name="input_ip_addresses"></a> [ip\_addresses](#input\_ip\_addresses) | A list of IP addresses in CIDR notation to include in the IP set. | `list(string)` | n/a | yes |
| <a name="input_ip_set_description"></a> [ip\_set\_description](#input\_ip\_set\_description) | A description of the IP set. | `string` | n/a | yes |
| <a name="input_ip_set_name"></a> [ip\_set\_name](#input\_ip\_set\_name) | The name of the IP set. | `string` | n/a | yes |
| <a name="input_scope"></a> [scope](#input\_scope) | (Required) Specifies whether this is for an AWS CloudFront distribution or for a regional application. Valid values are CLOUDFRONT or REGIONAL. To work with CloudFront, you must also specify the Region US East (N. Virginia). | `string` | `"REGIONAL"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the IP set. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The Amazon Resource Name (ARN) of the IP set. |
| <a name="output_id"></a> [id](#output\_id) | A unique identifier for the IP set. |
| <a name="output_tags_all"></a> [tags\_all](#output\_tags\_all) | A map of tags assigned to the IP set, including those inherited from the provider default\_tags configuration block. |
