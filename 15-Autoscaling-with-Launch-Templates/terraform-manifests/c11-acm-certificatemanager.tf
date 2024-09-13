# ACM Module - To create and Verify SSL Certificates
module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  #version = "2.14.0"
  #version = "3.0.0"
  version = "5.0.0"  

  domain_name  = trimsuffix(data.aws_route53_zone.mydomain.name, ".")
  zone_id      = data.aws_route53_zone.mydomain.zone_id 
  subject_alternative_names = [
    "*.devopsincloud.com"
  ]
  tags = local.common_tags
  # Validation Method
  validation_method = "DNS"
  wait_for_validation = true    
}

# Output ACM Certificate ARN
output "this_acm_certificate_arn" {
  description = "The ARN of the certificate"
  #value       = module.acm.this_acm_certificate_arn
  value       = module.acm.acm_certificate_arn
}

/*Certainly! DNS zones are a fundamental concept in the Domain Name System (DNS) infrastructure. They represent a portion of the DNS namespace that is managed by a specific organization or administrator.

In the context of AWS Route 53, a DNS zone (often called a hosted zone) is a container for DNS records related to a specific domain. These records define how domain names are translated into IP addresses and other resources.

Key points about DNS zones:

They contain resource records (like A, CNAME, MX records) for a domain and its subdomains.
Each zone has a unique identifier (the zone_id in AWS Route 53).
Zones allow for delegated management of different parts of a domain hierarchy.
In AWS, hosted zones can be public (accessible on the internet) or private (accessible only within specified VPCs).
The zone_id referenced in the provided code is used to link the ACM certificate with the correct DNS zone, enabling automated DNS validation and renewal processes for SSL/TLS certificates.*/