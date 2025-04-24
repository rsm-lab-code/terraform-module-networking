# inspection_vpc/outputs.tf

output "inspection_vpc_id" {
  description = "ID of the inspection VPC"
  value       = aws_vpc.inspection_vpc.id
}

output "inspection_vpc_cidr" {
  description = "CIDR block of the inspection VPC"
  value       = aws_vpc.inspection_vpc.cidr_block
}

output "inspection_public_subnet_ids" {
  description = "IDs of public subnets in the inspection VPC (for GWLB endpoints)"
  value       = aws_subnet.inspection_public_subnets[*].id
}

output "inspection_private_subnet_ids" {
  description = "IDs of private subnets in the inspection VPC (for security appliances)"
  value       = aws_subnet.inspection_private_subnets[*].id
}


output "nat_gateway_ids" {
  description = "IDs of the NAT gateways in the inspection VPC"
  value       = aws_nat_gateway.inspection_nat_gw[*].id
}

output "inspection_public_rt_id" {
  description = "ID of the public route table in the inspection VPC"
  value       = aws_route_table.inspection_public_rt.id
}

output "inspection_private_rt_ids" {
  description = "IDs of the private route tables in the inspection VPC"
  value       = aws_route_table.inspection_private_rt[*].id
}

