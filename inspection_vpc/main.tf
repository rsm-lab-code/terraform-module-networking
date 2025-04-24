

# Create the inspection VPC using IPAM allocation
resource "aws_vpc" "inspection_vpc" {
  provider             = aws.delegated_account_us-west-2
  ipv4_ipam_pool_id    = var.ipam_pool_id
  ipv4_netmask_length  = var.ipam_netmask_length
  enable_dns_support   = true
  enable_dns_hostnames = true
  
  tags = {
    Name        = "inspection-vpc"
    Environment = "security"
    ManagedBy   = "terraform"
  }
}

# Create internet gateway for the inspection VPC
resource "aws_internet_gateway" "inspection_igw" {
  provider = aws.delegated_account_us-west-2
  vpc_id   = aws_vpc.inspection_vpc.id
  
  tags = {
    Name        = "inspection-igw"
    Environment = "security"
    ManagedBy   = "terraform"
  }
}

# Create public subnets 
resource "aws_subnet" "inspection_public_subnets" {
  provider          = aws.delegated_account_us-west-2
  count             = var.public_subnet_count
  vpc_id            = aws_vpc.inspection_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.inspection_vpc.cidr_block, 8, count.index)
  availability_zone = "${var.aws_region}${var.az_suffixes[count.index % length(var.az_suffixes)]}"
  
  tags = {
    Name        = "inspection-public-${var.az_suffixes[count.index % length(var.az_suffixes)]}"
    Environment = "security"
    ManagedBy   = "terraform"
    Tier        = "public"
  }
}

# Create private subnets 
resource "aws_subnet" "inspection_private_subnets" {
  provider          = aws.delegated_account_us-west-2
  count             = var.private_subnet_count
  vpc_id            = aws_vpc.inspection_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.inspection_vpc.cidr_block, 8, count.index + var.public_subnet_count)
  availability_zone = "${var.aws_region}${var.az_suffixes[count.index % length(var.az_suffixes)]}"
  
  tags = {
    Name        = "inspection-private-${var.az_suffixes[count.index % length(var.az_suffixes)]}"
    Environment = "security"
    ManagedBy   = "terraform"
    Tier        = "private"
  }
}

# Create NAT gateways for outbound traffic
resource "aws_eip" "nat_eip" {
  provider = aws.delegated_account_us-west-2
  count    = var.public_subnet_count
  domain   = "vpc"
  
  tags = {
    Name        = "inspection-nat-eip-${var.az_suffixes[count.index % length(var.az_suffixes)]}"
    Environment = "security"
    ManagedBy   = "terraform"
  }
}

resource "aws_nat_gateway" "inspection_nat_gw" {
  provider      = aws.delegated_account_us-west-2
  count         = var.public_subnet_count
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.inspection_public_subnets[count.index].id
  
  tags = {
    Name        = "inspection-nat-gw-${var.az_suffixes[count.index % length(var.az_suffixes)]}"
    Environment = "security"
    ManagedBy   = "terraform"
  }
  
  depends_on = [aws_internet_gateway.inspection_igw]
}
