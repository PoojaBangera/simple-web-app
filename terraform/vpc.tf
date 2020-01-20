# vpc.tf 
# Create VPC/Subnet/Security Group/Network ACL
provider "aws" {
  version = "~> 2.0"
  access_key = var.access_key
  secret_key = var.secret_key
  region = var.region
}
# create the VPC
resource "aws_vpc" "My_VPC" {
  cidr_block = var.vpcCIDRblock
  instance_tenancy = var.instanceTenancy
  enable_dns_support = var.dnsSupport
  enable_dns_hostnames = var.dnsHostNames
  tags = {
    Name = "My VPC"
  }
}
# end resource
# create the Subnet
resource "aws_subnet" "My_VPC_Subnet1" {

  vpc_id = aws_vpc.My_VPC.id
  cidr_block = var.subnet1CIDRblock
  map_public_ip_on_launch = var.mapPublicIP
  availability_zone = var.availabilityZone1

  tags = {
    Name = "My VPC Subnet-1",
  }
}

resource "aws_subnet" "My_VPC_Subnet2" {

  vpc_id = aws_vpc.My_VPC.id
  cidr_block = var.subnet2CIDRblock
  map_public_ip_on_launch = var.mapPublicIP
  availability_zone = var.availabilityZone2

  tags = {
    Name = "My VPC Subnet-2",
  }

}
# end resource
# Create the Security Group
resource "aws_security_group" "My_VPC_Security_Group" {
  vpc_id = aws_vpc.My_VPC.id
  name = "My VPC Security Group"
  description = "My VPC Security Group"

  # allow ingress of port 22
  ingress {
    cidr_blocks = var.ingressCIDRblock
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  # allow ingress of port 22
  ingress {
    cidr_blocks = var.ingressCIDRblock
    from_port = 80
    to_port = 80
    protocol = "tcp"
  }
  ingress {
    cidr_blocks = var.ingressCIDRblock
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
  }

  # allow egress of all ports
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  tags = {
    Name = "My VPC Security Group"
    Description = "My VPC Security Group"
  }
}
# end resource

# Create the Internet Gateway
resource "aws_internet_gateway" "My_VPC_GW" {
  vpc_id = aws_vpc.My_VPC.id
  tags = {
    Name = "My VPC Internet Gateway"
  }
}
# end resource
# Create the Route Table
resource "aws_route_table" "My_VPC_route_table" {
  vpc_id = aws_vpc.My_VPC.id
  tags = {
    Name = "My VPC Route Table"
  }
}
# end resource

# Create the Internet Access
resource "aws_route" "My_VPC_internet_access" {
  route_table_id = aws_route_table.My_VPC_route_table.id
  destination_cidr_block = var.destinationCIDRblock
  gateway_id = aws_internet_gateway.My_VPC_GW.id
}
# end resource

# Associate the Route Table with the Subnet-1
resource "aws_route_table_association" "My_VPC_association_1" {
  subnet_id = aws_subnet.My_VPC_Subnet1.id
  route_table_id = aws_route_table.My_VPC_route_table.id
}
# end resource

# Associate the Route Table with the Subnet-2
resource "aws_route_table_association" "My_VPC_association_2" {
  subnet_id = aws_subnet.My_VPC_Subnet2.id
  route_table_id = aws_route_table.My_VPC_route_table.id
}
# end resource

resource "aws_main_route_table_association" "a" {
  vpc_id = aws_vpc.My_VPC.id
  route_table_id = aws_route_table.My_VPC_route_table.id
}
# end vpc.tf
