# Public Route Tables (base configuration without routes)
resource "aws_route_table" "public_rt_west" {
  provider = aws.delegated_account_us-west-2
  vpc_id   = aws_vpc.vpc_west.id
  
  tags = {
    Name        = "${var.vpc_names["us-west-2"]}-public-rt"
    Environment = "Production"
  }
}

resource "aws_route_table" "public_rt_east" {
  provider = aws.delegated_account_us-east-1
  vpc_id   = aws_vpc.vpc_east.id
  
  tags = {
    Name        = "${var.vpc_names["us-east-1"]}-public-rt"
    Environment = "NonProduction"
  }
}

# Private Route Tables (base configuration without routes)
resource "aws_route_table" "private_rt_west" {
  provider = aws.delegated_account_us-west-2
  vpc_id   = aws_vpc.vpc_west.id
  
  tags = {
    Name        = "${var.vpc_names["us-west-2"]}-private-rt"
    Environment = "Production"
  }
}

resource "aws_route_table" "private_rt_east" {
  provider = aws.delegated_account_us-east-1
  vpc_id   = aws_vpc.vpc_east.id
  
  tags = {
    Name        = "${var.vpc_names["us-east-1"]}-private-rt"
    Environment = "NonProduction"
  }
}

# Define separate route resources for public route tables
resource "aws_route" "public_default_west" {
  provider               = aws.delegated_account_us-west-2
  route_table_id         = aws_route_table.public_rt_west.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_west.id
}

resource "aws_route" "public_default_east" {
  provider               = aws.delegated_account_us-east-1
  route_table_id         = aws_route_table.public_rt_east.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_east.id
}

# Define separate route resources for private route tables
resource "aws_route" "private_default_west" {
  provider               = aws.delegated_account_us-west-2
  route_table_id         = aws_route_table.private_rt_west.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw_west.id
}

resource "aws_route" "private_default_east" {
  provider               = aws.delegated_account_us-east-1
  route_table_id         = aws_route_table.private_rt_east.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw_east.id
}

# Route Table Associations (unchanged)
# Assuming first subnet (index 0) is public and second subnet (index 1) is private
resource "aws_route_table_association" "public_rta_west" {
  provider       = aws.delegated_account_us-west-2
  subnet_id      = aws_subnet.subnet_west[0].id
  route_table_id = aws_route_table.public_rt_west.id
}

resource "aws_route_table_association" "private_rta_west" {
  provider       = aws.delegated_account_us-west-2
  subnet_id      = aws_subnet.subnet_west[1].id
  route_table_id = aws_route_table.private_rt_west.id
}

resource "aws_route_table_association" "public_rta_east" {
  provider       = aws.delegated_account_us-east-1
  subnet_id      = aws_subnet.subnet_east[0].id
  route_table_id = aws_route_table.public_rt_east.id
}

resource "aws_route_table_association" "private_rta_east" {
  provider       = aws.delegated_account_us-east-1
  subnet_id      = aws_subnet.subnet_east[1].id
  route_table_id = aws_route_table.private_rt_east.id
}