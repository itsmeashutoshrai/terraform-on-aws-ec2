# Security Group for Public Load Balancer
module "loadbalancer_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  #version = "3.18.0"
  version = "5.1.0"

  name = "loadbalancer-sg"
  description = "Security Group with HTTP open for entire Internet (IPv4 CIDR), egress ports are all world open"
  vpc_id = module.vpc.vpc_id
  # Ingress Rules & CIDR Blocks
  ingress_rules = ["http-80-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  # Egress Rule - all-all open
  egress_rules = ["all-all"]
  tags = local.common_tags

  # Open to CIDRs blocks (rule or from_port+to_port+protocol+description)
  ingress_with_cidr_blocks = [
    {
      from_port   = 81
      to_port     = 81
      protocol    = 6
      description = "Allow Port 81 from internet"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}
#In the context of the Terraform configuration you provided, from_port and to_port are parameters used to define the range of port numbers for which a security rule applies.
#Here's a breakdown of what these terms mean:

# from_port: This is the starting port number for the range of ports that you want to allow or deny traffic through. If you are specifying a single port, from_port will be equal to to_port.

# to_port: This is the ending port number for the range of ports that you want to allow or deny traffic through. If you are specifying a single port, to_port will be equal to from_port.
# from_port = 81: This indicates the starting port number is 81.
# to_port = 81: This indicates the ending port number is 81.
# protocol = 6: This represents the protocol being used. The value 6 corresponds to TCP (Transmission Control Protocol).
# description = "Allow Port 81 from internet": This is a human-readable description of what the rule is doing.
# cidr_blocks = "0.0.0.0/0": This allows traffic from any IP address (IPv4) on the internet.
# In this case, the rule is allowing TCP traffic on port 81 from any IP address on the internet.

# Security Group Rules
# Ingress rules define the inbound traffic allowed to the resources associated with the security group.
# Egress rules define the outbound traffic allowed from the resources associated with the security group.

