# Transit Gateway - central hub for VPC connectivity
resource "aws_ec2_transit_gateway" "tgw" {
  provider = aws.delegated_account_us-west-2
  
  description                     = "Transit Gateway us-west-2"
  amazon_side_asn                 = var.amazon_side_asn
  auto_accept_shared_attachments  = "enable"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  dns_support                     = "enable"
  vpn_ecmp_support                = "enable"
  
  tags = {
    Name        = var.tgw_name
    Environment = "shared"
    ManagedBy   = "terraform"
  }
}

# Default Transit Gateway Route Table
resource "aws_ec2_transit_gateway_route_table" "tgw_rt" {
  provider = aws.delegated_account_us-west-2
  
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  
  tags = {
    Name        = "${var.tgw_name}-rt"
    Environment = "shared"
    ManagedBy   = "terraform"
  }
}
