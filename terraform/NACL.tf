/*resource "aws_network_acl" "My_VPC_Security_ACL" {
  vpc_id     = aws_vpc.My_VPC.id
  subnet_ids = [aws_subnet.My_VPC_Subnet1.id, aws_subnet.My_VPC_Subnet2.id]


  # allow ingress port 80
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 80
    to_port    = 80
  }

  # allow ingress port 80
  ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 443
    to_port    = 443
  }

  # allow ingress ephemeral ports
  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 1024
    to_port    = 65535
  }*/
/*
# allow ingress ephemeral ports
ingress {
  protocol   = "tcp"
  rule_no    = 120
  action     = "allow"
  cidr_block = var.destinationCIDRblock
  from_port  = 22
  to_port    = 22
}
# allow egress port 22
ingress {
  protocol   = "tcp"
  rule_no    = 130
  action     = "allow"
  cidr_block = var.destinationCIDRblock
  from_port  = 3000
  to_port    = 3000
}

# allow egress port 80
egress {
  protocol   = "tcp"
  rule_no    = 100
  action     = "allow"
  cidr_block = var.destinationCIDRblock
  from_port  = 80
  to_port    = 80
}

# allow egress ephemeral ports
egress {
  protocol   = "tcp"
  rule_no    = 110
  action     = "allow"
  cidr_block = var.destinationCIDRblock
  from_port  = 443
  to_port    = 443
}

egress {
  protocol   = "tcp"
  rule_no    = 120
  action     = "allow"
  cidr_block = var.internet_cidr_block
  from_port  = 3000
  to_port    = 3000
}
tags = {
  Name = "My VPC ACL"
}
} # end resource
*/