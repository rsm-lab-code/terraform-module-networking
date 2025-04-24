resource "aws_vpc" "spoke1_vpc" {
  provider = aws.delegated_account_us-west-2
  
  # Use IPAM pool for IP assignment
  ipv4_ipam_pool_id   = var.ipam_pool_ids["us-west-2-prod"]
  ipv4_netmask_length = 21
  
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = {
    Name        = var.inspection_vpc_names["spoke1"]
    Environment = "Production"
    Tier        = "Spoke"
  }
}

# Create spoke2 VPC in us-west-2 using production pool
resource "aws_vpc" "spoke2_vpc" {
  provider = aws.delegated_account_us-west-2
  
  # Use IPAM pool for IP assignment
  ipv4_ipam_pool_id   = var.ipam_pool_ids["us-west-2-prod"]
  ipv4_netmask_length = 21
  
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = {
    Name        = var.inspection_vpc_names["spoke2"]
    Environment = "Production"
    Tier        = "Spoke"
  }
}
