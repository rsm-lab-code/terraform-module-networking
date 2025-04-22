# Attach the VPC in us-west-2 to the Transit Gateway
resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_west_attachment" {
  provider = aws.delegated_account_us-west-2
  
  subnet_ids         = var.vpc_west_subnet_ids
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = var.vpc_west_id
  
  dns_support                                     = "enable"
  transit_gateway_default_route_table_association = true
  transit_gateway_default_route_table_propagation = true
  
  tags = {
    Name        = "${var.vpc_names["us-west-2"]}-tgw-attachment"
    Environment = "Production"
    ManagedBy   = "terraform"
  }
}

