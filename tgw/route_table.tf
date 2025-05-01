# Routes from us-west-2 to us-east-1
resource "aws_route" "west_public_to_east" {
  provider = aws.delegated_account_us-west-2
  
  route_table_id         = var.vpc_west_route_table_ids["public"]
  destination_cidr_block = var.vpc_east_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id
}

resource "aws_route" "west_private_to_east" {
  provider = aws.delegated_account_us-west-2
  
  route_table_id         = var.vpc_west_route_table_ids["private"]
  destination_cidr_block = var.vpc_east_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id
}

# Routes from us-east-1 to us-west-2
resource "aws_route" "east_public_to_west" {
  provider = aws.delegated_account_us-east-1

  route_table_id         = var.vpc_east_route_table_ids["public"]
  destination_cidr_block = var.vpc_west_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.tgw_east.id
}

resource "aws_route" "east_private_to_west" {
  provider = aws.delegated_account_us-east-1

  route_table_id         = var.vpc_east_route_table_ids["private"]
  destination_cidr_block = var.vpc_west_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.tgw_east.id
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
