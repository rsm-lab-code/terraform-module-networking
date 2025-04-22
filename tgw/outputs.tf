output "transit_gateway_id" {
  description = "ID of the created Transit Gateway"
  value       = aws_ec2_transit_gateway.tgw.id
}

output "transit_gateway_arn" {
  description = "ARN of the created Transit Gateway"
  value       = aws_ec2_transit_gateway.tgw.arn
}

output "transit_gateway_route_table_id" {
  description = "ID of the Transit Gateway route table"
  value       = aws_ec2_transit_gateway_route_table.tgw_rt.id
}

output "vpc_west_attachment_id" {
  description = "ID of the us-west-2 VPC attachment"
  value       = aws_ec2_transit_gateway_vpc_attachment.vpc_west_attachment.id
}

