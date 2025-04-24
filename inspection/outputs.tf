# outputs.tf
output "spoke1_vpc_id" {
  description = "The ID of the spoke1 VPC"
  value       = aws_vpc.spoke1_vpc.id
}

output "spoke2_vpc_id" {
  description = "The ID of the spoke2 VPC"
  value       = aws_vpc.spoke2_vpc.id
}

output "spoke1_vpc_cidr" {
  description = "The CIDR block of the spoke1 VPC"
  value       = aws_vpc.spoke1_vpc.cidr_block
}

output "spoke2_vpc_cidr" {
  description = "The CIDR block of the spoke2 VPC"
  value       = aws_vpc.spoke2_vpc.cidr_block
}


output "vpc_regions" {
  description = "Regions where VPCs are created"
  value       = var.aws_regions
}
