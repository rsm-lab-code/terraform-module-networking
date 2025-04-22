# Security group for west (us-west-2) instances
resource "aws_security_group" "west_test_sg" {
  provider    = aws.delegated_account_us-west-2
  name        = "west-test-sg"
  description = "Security group for testing TGW connectivity"
  vpc_id      = var.vpc_west_id
  
  # Allow ICMP (ping) from the east VPC CIDR
  ingress {
    from_port   = -1  # ICMP
    to_port     = -1  # ICMP
    protocol    = "icmp"
    cidr_blocks = [var.vpc_east_cidr]
    description = "Allow ping from east VPC"
  }
  
  # Allow SSH from your IP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["your-ip-address/32"]
    description = "Allow SSH from admin IP"
  }
  
  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security group for east (us-east-1) instances
resource "aws_security_group" "east_test_sg" {
  provider    = aws.delegated_account_us-east-1
  name        = "east-test-sg"
  description = "Security group for testing TGW connectivity"
  vpc_id      = var.vpc_east_id
  
  # Allow ICMP (ping) from the west VPC CIDR
  ingress {
    from_port   = -1  # ICMP
    to_port     = -1  # ICMP
    protocol    = "icmp"
    cidr_blocks = [var.vpc_west_cidr]
    description = "Allow ping from west VPC"
  }
  
  # Allow SSH from your IP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["your-ip-address/32"]
    description = "Allow SSH from admin IP"
  }
  
  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
