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

# Attach the VPC in us-east-1 to the Transit Gateway in us-east-1
resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_east_attachment" {
  provider = aws.delegated_account_us-east-1

  subnet_ids         = var.vpc_east_subnet_ids
  transit_gateway_id = aws_ec2_transit_gateway.tgw_east.id
  vpc_id             = var.vpc_east_id

  dns_support                                     = "enable"
  transit_gateway_default_route_table_association = true
  transit_gateway_default_route_table_propagation = true

  tags = {
    Name        = "${var.vpc_names["us-east-1"]}-tgw-attachment"
    Environment = "Non-Production"
    ManagedBy   = "terraform"
  }
}

#Enable route propagation

resource "aws_ec2_transit_gateway_route_table_propagation" "west_to_tgw" {
  provider = aws.delegated_account_us-west-2
  
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_west_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "east_to_tgw" {
  provider = aws.delegated_account_us-east-1
  
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_east_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt_east.id
}


# Associate the west VPC attachment with the TGW route table
resource "aws_ec2_transit_gateway_route_table_association" "vpc_west_rt_association" {
  provider                       = aws.delegated_account_us-west-2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_west_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt.id
}

# Associate the east VPC attachment with the TGW route table
resource "aws_ec2_transit_gateway_route_table_association" "vpc_east_rt_association" {
  provider                       = aws.delegated_account_us-east-1
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_east_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt_east.id
}

# Associate the peering attachments
resource "aws_ec2_transit_gateway_route_table_association" "tgw_peering_west_rt_association" {
  provider                       = aws.delegated_account_us-west-2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.tgw_peering.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt.id

  depends_on = [aws_ec2_transit_gateway_peering_attachment_accepter.tgw_peering_accepter]
}

resource "aws_ec2_transit_gateway_route_table_association" "tgw_peering_east_rt_association" {
  provider                       = aws.delegated_account_us-east-1
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.tgw_peering.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt_east.id

  depends_on = [aws_ec2_transit_gateway_peering_attachment_accepter.tgw_peering_accepter]
}
