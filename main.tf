### Terraform Cloud Info as Backend Storage and execution ###
terraform {
  cloud {
    hostname     = "app.terraform.io"
    organization = "Insideinfo"
    workspaces {
      name = "INSIDE_AWS_LABNET"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.7.0"
    }
  }
}

### AWS Provider Info ###
provider "aws" {
  region = var.region
}

### AWS COMMON TAGS ###
locals {
  common-tags = {
    author      = "DonghwanLim"
    system      = "LAB"
    Environment = "INSIDE__AWS_NETWORK"
  }
}

### AWS Data AZ List ###
data "aws_availability_zones" "all" {}

### AWS VPC ###
resource "aws_vpc" "vpc01" {
  cidr_block           = "10.10.10.0/24"
  enable_dns_hostnames = true
  enable_dns_support   = true
  #main_route_table_id = aws_route_table.vpc01-rt-public.id

  tags = (merge(local.common-tags, tomap({
    Name     = "vpc01"
    resource = "aws_vpc"
  })))
}

resource "aws_vpc" "vpc02" {
  cidr_block           = "10.10.20.0/24"
  enable_dns_hostnames = true
  enable_dns_support   = true
  #main_route_table_id = aws_route_table.

  tags = (merge(local.common-tags, tomap({
    Name     = "vpc02"
    resource = "aws_vpc"
  })))
}

### Internet GW For VPC01 ###
resource "aws_internet_gateway" "igw01" {
  vpc_id = aws_vpc.vpc01.id
  tags = (merge(local.common-tags, tomap({
    Name     = "igw-01"
    resource = "aws_internet_gateway"
  })))
}

### NAT GW FOR Private Network
resource "aws_nat_gateway" "ngw01" {
  allocation_id = aws_eip.ngw-eip-01.id
  subnet_id     = aws_subnet.vpc01-sbn-pub-01.id

  tags = {
    Name = "ngw01"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw01]
}

resource "aws_eip" "ngw-eip-01" {

}

### AWS Subnet ###
resource "aws_subnet" "vpc01-sbn-pub-01" {
  vpc_id                  = aws_vpc.vpc01.id
  availability_zone       = data.aws_availability_zones.all.names[0]
  cidr_block              = "10.10.10.0/26"
  map_public_ip_on_launch = true
  tags = (merge(local.common-tags, tomap({
    Name                                   = "vpc01-pub01-sbn"
    resource                               = "aws_subnet"
    "kubernetes.io/cluster/INSIDE_learnk8" = "shared"
    "kubernetes.io/role/elb"               = "1"
  })))
}

resource "aws_subnet" "vpc01-sbn-pub-02" {
  vpc_id                  = aws_vpc.vpc01.id
  availability_zone       = data.aws_availability_zones.all.names[2]
  cidr_block              = "10.10.10.64/26"
  map_public_ip_on_launch = true
  tags = (merge(local.common-tags, tomap({
    Name                                   = "vpc01-pub02-sbn"
    resource                               = "aws_subnet"
    "kubernetes.io/cluster/INSIDE_learnk8" = "shared"
    "kubernetes.io/role/elb"               = "1"
  })))
}

resource "aws_subnet" "vpc01-sbn-priv-01" {
  vpc_id            = aws_vpc.vpc01.id
  availability_zone = data.aws_availability_zones.all.names[0]
  cidr_block        = "10.10.10.128/26"
  tags = (merge(local.common-tags, tomap({
    Name                                    = "vpc01-priv01-sbn"
    resource                                = "aws_subnet"
    "kubernetes.io/cluster/INSIDE_learnk8s" = "shared"
    "kubernetes.io/role/internal-elb"       = "1"
  })))
}

resource "aws_subnet" "vpc01-sbn-priv-02" {
  vpc_id            = aws_vpc.vpc01.id
  availability_zone = data.aws_availability_zones.all.names[2]
  cidr_block        = "10.10.10.192/26"
  tags = (merge(local.common-tags, tomap({
    Name                                    = "vpc01-priv02-sbn"
    resource                                = "aws_subnet"
    "kubernetes.io/cluster/INSIDE_learnk8s" = "shared"
    "kubernetes.io/role/internal-elb"       = "1"
  })))
}
/*
resource "aws_subnet" "vpc02-sbn-pub-01" {
  vpc_id            = aws_vpc.vpc02.id
  availability_zone = data.aws_availability_zones.all.names[0]
  cidr_block        = "10.10.20.0/26"
  tags = (merge(local.common-tags, tomap({
    Name     = "vpc02-pub01-sbn"
    resource = "aws_subnet"
  })))
}

resource "aws_subnet" "vpc02-sbn-pub-02" {
  vpc_id            = aws_vpc.vpc02.id
  availability_zone = data.aws_availability_zones.all.names[2]
  cidr_block        = "10.10.20.64/26"
  tags = (merge(local.common-tags, tomap({
    Name     = "vpc02-pub02-sbn"
    resource = "aws_subnet"
  })))
}
*/
resource "aws_subnet" "vpc02-sbn-priv-01" {
  vpc_id            = aws_vpc.vpc02.id
  availability_zone = data.aws_availability_zones.all.names[0]
  cidr_block        = "10.10.20.128/26"
  tags = (merge(local.common-tags, tomap({
    Name     = "vpc02-priv01-sbn"
    resource = "aws_subnet"
  })))
}

resource "aws_subnet" "vpc02-sbn-priv-02" {
  vpc_id            = aws_vpc.vpc02.id
  availability_zone = data.aws_availability_zones.all.names[2]
  cidr_block        = "10.10.20.192/26"
  tags = (merge(local.common-tags, tomap({
    Name     = "vpc02-priv02-sbn"
    resource = "aws_subnet"
  })))
}


### Route Table ###
# vpc1 public route table
resource "aws_default_route_table" "vpc01-rt-public" {
  default_route_table_id = aws_vpc.vpc01.default_route_table_id

  /* aws_route resource로 이전
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw01.id
  }*/

  tags = (merge(local.common-tags, tomap({
    Name     = "VPC01-PUBLIC-RT"
    resource = "aws_default_route_table"
  })))
}

resource "aws_route" "vpc01-rt-pub-route01" {
  route_table_id         = aws_default_route_table.vpc01-rt-public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw01.id
}

resource "aws_route" "vpc01-rt-pub-route02" {
  route_table_id         = aws_default_route_table.vpc01-rt-public.id
  destination_cidr_block = "10.10.20.0/24"
  transit_gateway_id     = aws_ec2_transit_gateway.tgw01.id
}

resource "aws_route_table_association" "vpc01-rt-pub-to-sbn-pub01" {
  route_table_id = aws_default_route_table.vpc01-rt-public.id
  subnet_id      = aws_subnet.vpc01-sbn-pub-01.id
}

resource "aws_route_table_association" "vpc01-rt-pub-to-sbn-pub02" {
  route_table_id = aws_default_route_table.vpc01-rt-public.id
  subnet_id      = aws_subnet.vpc01-sbn-pub-02.id
}


# vpc1 private route table
/*
resource "aws_default_route_table" "vpc01-rt-private" {
  default_route_table_id = aws_vpc.vpc01.default_route_table_id

  tags = (merge(local.common-tags, tomap({
    Name     = "VPC01-PRIVATE-RT"
    resource = "aws_deafult_route_table"
  })))
}*/

resource "aws_route_table" "vpc01-rt-private" {
  vpc_id = aws_vpc.vpc01.id

  tags = (merge(local.common-tags, tomap({
    Name     = "VPC01-PRIVATE-RT"
    resource = "aws_route_table"
  })))
}

resource "aws_route_table_association" "vpc01-rt-priv-to-sbn-priv01" {
  route_table_id = aws_route_table.vpc01-rt-private.id
  subnet_id      = aws_subnet.vpc01-sbn-priv-01.id
}

resource "aws_route_table_association" "vpc01-rt-priv-to-sbn-priv02" {
  route_table_id = aws_route_table.vpc01-rt-private.id
  subnet_id      = aws_subnet.vpc01-sbn-priv-02.id
}

resource "aws_route" "vpc01-rt-priv-route01" {
  route_table_id         = aws_route_table.vpc01-rt-private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id      = aws_nat_gateway.ngw01.id
}

#vpc2 public route table
/*
resource "aws_route_table" "vpc02-rt-public" {
  vpc_id = aws_vpc.vpc02.id

  tags = (merge(local.common-tags, tomap({
    Name     = "VPC02-PUBLIC-RT"
    resource = "aws_route_table"
  })))
}

resource "aws_route_table_association" "vpc02-rt-pub-to-sbn-pub01" {
  route_table_id = aws_route_table.vpc02-rt-public.id
  subnet_id      = aws_subnet.vpc02-sbn-pub-01.id
}

resource "aws_route_table_association" "vpc02-rt-pub-to-sbn-pub02" {
  route_table_id = aws_route_table.vpc02-rt-public.id
  subnet_id      = aws_subnet.vpc02-sbn-pub-02.id
}
*/

#vpc2 private route table
resource "aws_default_route_table" "vpc02-rt-private" {
  default_route_table_id = aws_vpc.vpc02.default_route_table_id

  tags = (merge(local.common-tags, tomap({
    Name     = "VPC02-PRIVATE-RT"
    resource = "aws_route_table"
  })))
}

resource "aws_route" "vpc02-rt-priv-route01" {
  route_table_id         = aws_default_route_table.vpc02-rt-private.id
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = aws_ec2_transit_gateway.tgw01.id
}

resource "aws_route_table_association" "vpc02-rt-priv-to-sbn-priv01" {
  route_table_id = aws_default_route_table.vpc02-rt-private.id
  subnet_id      = aws_subnet.vpc02-sbn-priv-01.id
}

resource "aws_route_table_association" "vpc02-rt-priv-to-sbn-priv02" {
  route_table_id = aws_default_route_table.vpc02-rt-private.id
  subnet_id      = aws_subnet.vpc02-sbn-priv-02.id
}


#########################################################################
############################ Transit Gateway ############################
#########################################################################

resource "aws_ec2_transit_gateway" "tgw01" {
  description = "tgw between vpc1 and vpc2"
  
  tags = (merge(local.common-tags, tomap({
    Name     = "Transit_Gateway_Donghwan"
    resource = "aws_transit_gateway"
  })))
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw01-attach-vpc01" {
  subnet_ids         = [aws_subnet.vpc01-sbn-priv-01.id, aws_subnet.vpc01-sbn-priv-02.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw01.id
  vpc_id             = aws_vpc.vpc01.id
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw01-attach-vpc02" {
  subnet_ids         = [aws_subnet.vpc02-sbn-priv-01.id, aws_subnet.vpc02-sbn-priv-02.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw01.id
  vpc_id             = aws_vpc.vpc02.id
}

resource "aws_ec2_transit_gateway_route_table" "tgw01-routetable" {
  
  transit_gateway_id = aws_ec2_transit_gateway.tgw01.id

  tags = (merge(local.common-tags, tomap({
    Name     = "TGW_Route_Table"
    resource = "aws_transit_gateway_route_table"
  })))
}


import {
  to = aws_ec2_transit_gateway_route_table.tgw01-routetable
  id = "tgw-rtb-08133dced42ca6b30"
}


resource "aws_ec2_transit_gateway_route" "tgw01-route" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw01-attach-vpc01.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw01-routetable.id
}
