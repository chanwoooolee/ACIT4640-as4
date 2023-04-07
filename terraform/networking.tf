# This block specifies the required provider and version for the Terraform configuration.
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

# This block specifies the provider and region for the resources in this configuration.
provider "aws" {
  region = "us-west-2"
}

# This block defines a variable to specify the default CIDR block for the VPC.
variable "base_cidr_block" {
  description = "default cidr block for vpc"
  default     = "10.0.0.0/16"
}

# This block creates the main VPC resource with the specified CIDR block and instance tenancy.
resource "aws_vpc" "main" {
  cidr_block       = var.base_cidr_block
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

# This block creates a public subnet for the main VPC in us-west-2a with a specified CIDR block.
resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "main"
  }
}

# This block creates a private subnet for RDS instances in us-west-2a with a specified CIDR block.
resource "aws_subnet" "rds-sn1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "rds-sn1"
  }
}

# This block creates a private subnet for RDS instances in us-west-2b with a specified CIDR block.
resource "aws_subnet" "rds-sn2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "rds-sn2"
  }
}

# This block creates an internet gateway resource and associates it with the main VPC.
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main-ipg"
  }
}

# This block creates a route table for the main VPC.
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-route"
  }
}

# This block creates a default route in the main route table that points to the internet gateway.
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.main.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

# This block associates the main route table with the main subnet.
resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

