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
  #main_route_table_id = aws_route_table.vpc01-rt-private.id

  tags = (merge(local.common-tags, tomap({
    Name     = "vpc01"
    resource = "aws_vpc"
  })))
}

resource "aws_vpc" "vpc02" {
  cidr_block           = "10.10.20.0/24"
  enable_dns_hostnames = true
  enable_dns_support   = true
  #main_route_table_id = aws_route_table.vpc02-rt-private.id

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


### AWS Subnet ###
resource "aws_subnet" "vpc01-sbn-pub-01" {
  vpc_id            = aws_vpc.vpc01.id
  availability_zone = data.aws_availability_zones.all.names[0]
  cidr_block        = "10.10.10.0/26"
  tags = (merge(local.common-tags, tomap({
    Name                                   = "vpc01-pub01-sbn"
    resource                               = "aws_subnet"
    "kubernetes.io/cluster/INSIDE_learnk8" = "shared"
    "kubernetes.io/role/elb"               = "1"
  })))
}

resource "aws_subnet" "vpc01-sbn-pub-02" {
  vpc_id            = aws_vpc.vpc01.id
  availability_zone = data.aws_availability_zones.all.names[2]
  cidr_block        = "10.10.10.64/26"
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
resource "aws_route_table" "vpc01-rt-public" {
  vpc_id = aws_vpc.vpc01.id

  /*
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw01.id
  }
  */
  tags = (merge(local.common-tags, tomap({
    Name     = "VPC01-PUBLIC-RT"
    resource = "aws_route_table"
  })))
}

resource "aws_route" "vpc01-rt-pub-route01" {
  route_table_id = aws_route_table.vpc01-rt-public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw01.id
}

resource "aws_route_table_association" "vpc01-rt-pub-to-sbn-pub01" {
  route_table_id = aws_route_table.vpc01-rt-public.id
  subnet_id      = aws_subnet.vpc01-sbn-pub-01.id
}

resource "aws_route_table_association" "vpc01-rt-pub-to-sbn-pub02" {
  route_table_id = aws_route_table.vpc01-rt-public.id
  subnet_id      = aws_subnet.vpc01-sbn-pub-02.id
}


# vpc1 private route table
resource "aws_default_route_table" "vpc01-rt-private" {
  default_route_table_id = aws_vpc.vpc01.default_route_table_id

  tags = (merge(local.common-tags, tomap({
    Name     = "VPC01-PRIVATE-RT"
    resource = "aws_deafult_route_table"
  })))
}

resource "aws_route_table_association" "vpc01-rt-priv-to-sbn-priv01" {
  route_table_id = aws_default_route_table.vpc01-rt-private.id
  subnet_id      = aws_subnet.vpc01-sbn-priv-01.id
}

resource "aws_route_table_association" "vpc01-rt-priv-to-sbn-priv02" {
  route_table_id = aws_default_route_table.vpc01-rt-private.id
  subnet_id      = aws_subnet.vpc01-sbn-priv-02.id
}


#vpc2 public route table
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


#vpc2 private route table
resource "aws_default_route_table" "vpc02-rt-private" {
  default_route_table_id = aws_vpc.vpc02.default_route_table_id

  tags = (merge(local.common-tags, tomap({
    Name     = "VPC02-PRIVATE-RT"
    resource = "aws_route_table"
  })))
}

resource "aws_route_table_association" "vpc02-rt-priv-to-sbn-priv01" {
  route_table_id = aws_default_route_table.vpc02-rt-private.id
  subnet_id      = aws_subnet.vpc02-sbn-priv-01.id
}

resource "aws_route_table_association" "vpc02-rt-priv-to-sbn-priv02" {
  route_table_id = aws_default_route_table.vpc02-rt-private.id
  subnet_id      = aws_subnet.vpc02-sbn-priv-02.id
}