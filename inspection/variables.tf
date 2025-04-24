variable "aws_regions" {
  type        = list(string)
  description = "List of AWS regions for VPC creation"
  default     = ["us-west-2", "us-east-1"]
}

variable "inspection_vpc_names" {
  description = "Names for the VPCs in each region"
  type        = map(string)
  default = {
    "spoke1" = "spoke1 vpc"
    "spoke1" = "spoke2"
  }
}


variable "ipam_pool_ids" {
  description = "IDs of IPAM pools to use for each VPC"
  type        = map(string)
}


