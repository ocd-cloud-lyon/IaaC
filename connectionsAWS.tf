provider "aws" {
  assume_role {
    role_arn     = "arn:aws:iam::573329840855:role/AccessLyon"
  }
}

# Create a VPC
#resource "aws_vpc" "sma-example" {
#  cidr_block = "10.70.0.0/16"
#}

