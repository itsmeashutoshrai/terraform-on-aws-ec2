# DNS Registration 
resource "aws_route53_record" "apps_dns" {
  zone_id = data.aws_route53_zone.mydomain.zone_id 
  name    = "asg-lt.devopsincloud.com"
  type    = "A"
  alias {
    #name                   = module.alb.lb_dns_name
    #zone_id                = module.alb.lb_zone_id
    name                   = module.alb.dns_name
    zone_id                = module.alb.zone_id
    evaluate_target_health = true
  }  
}

#TTL for all alias records is 60 seconds, you cannot change this, therefore ttl has to be omitted in alias records.
/*In the context of `aws_route53_record` in Terraform, the term **alias** can be used in two distinct ways:

### 1. **Alias Records for AWS Services**
An **alias record** in AWS Route 53 is a special type of DNS record that you can use to point a domain name to an AWS resource, such as an S3 bucket, a CloudFront distribution, or an Elastic Load Balancer (ELB). Unlike standard DNS records, alias records are specific to AWS and allow for more seamless integration with AWS services.

When you create an `aws_route53_record` with an alias, you use the `alias` block within the resource to specify the AWS resource to which the alias should point.

#### Example:
```hcl
resource "aws_route53_record" "alias" {
  zone_id = "Z3M3LMPEXAMPLE"  # The ID of the Route 53 hosted zone
  name    = "example.com"      # The domain name
  type    = "A"                # The DNS record type, often "A" or "AAAA"

  alias {
    name                   = aws_lb.myloadbalancer.dns_name  # The DNS name of the AWS resource
    zone_id                = aws_lb.myloadbalancer.zone_id   # The Route 53 hosted zone ID of the AWS resource
    evaluate_target_health = true                            # Whether Route 53 should evaluate the health of the target resource
  }
}
```

- **`name`**: The DNS name of the AWS resource you are pointing to (e.g., the DNS name of an ELB).
- **`zone_id`**: The Route 53 hosted zone ID associated with the resource.
- **`evaluate_target_health`**: A boolean value that specifies whether Route 53 should check the health of the target resource before returning it in response to DNS queries.

### 2. **Alias for Resource References**
In Terraform, the term **alias** can also be used more generally as an identifier for referencing different instances of the same resource or provider configuration, but this is not specific to `aws_route53_record`. Instead, this use of `alias` applies to provider configurations.

#### Example of Provider Alias (Not Specific to `aws_route53_record`):
```hcl
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "us_west_2"
  region = "us-west-2"
}

resource "aws_instance" "example" {
  provider = aws.us_west_2  # Reference to the provider alias
  # Other instance configuration
}
```

This example shows how you might use a provider alias to reference different AWS regions or accounts within the same Terraform configuration.

### Summary
- **Alias Records**: In `aws_route53_record`, the `alias` block is used to create special DNS records that point to AWS resources like ELBs or CloudFront distributions.
- **Provider Aliases**: Although not directly related to `aws_route53_record`, provider aliases allow you to manage multiple configurations of the same provider within a single Terraform module.*/