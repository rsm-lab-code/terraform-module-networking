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

