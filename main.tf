### Terraform Cloud Info as Backend Storage and execution ###
terraform {
  cloud {
    hostname = "app.terraform.io"
    organization = "Insideinfo"
    workspaces {
      name = "INSIDE_AWS_LABNET"
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
    author = "DonghwanLim"
    system = "LAB"
    Environment = "INSIDE__AWS_NETWORK"
  }
}

### AWS Data AZ List ###
data "aws_availability_zones" "all" {}

### AWS VPC ###
resource "aws_vpc" "vpc01" {
  cidr_block = "10.10.10.0/24"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = (merge(local.common-tags, tomap({
    Name = "vpc01"
    resource = "aws_vpc"
  })))
}

resource "aws_vpc" "vpc02" {
  cidr_block = "10.10.20.0/24"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = (merge(local.common-tags, tomap({
    Name = "vpc02"
    resource = "aws_vpc"
  })))
}


### AWS Subnet ###
resource "aws_subnet" "vpc01-sbn-pub-01" {
  vpc_id = aws_vpc.vpc01.id
  availability_zone = data.aws_availability_zones.all.name[0]
  cidr_block = "10.10.10.0/26"
  tags = (merge(local.common-tags, tomap ({
    Name = "vpc01-pub01-sbn"
    resource = "aws_subnet"
  })))
}

resource "aws_subnet" "vpc01-sbn-pub-02" {
  vpc_id = aws_vpc.vpc01.id
  availability_zone = data.aws_availability_zones.all.name[2]
  cidr_block = "10.10.10.64/26"
  tags = (merge(local.common-tags, tomap ({
    Name = "vpc01-pub02-sbn"
    resource = "aws_subnet"
  })))
}

resource "aws_subnet" "vpc01-sbn-priv-01" {
  vpc_id = aws_vpc.vpc01.id
  availability_zone = data.aws_availability_zones.all.name[0]
  cidr_block = "10.10.10.128/26"
  tags = (merge(local.common-tags, tomap ({
    Name = "vpc01-priv01-sbn"
    resource = "aws_subnet"
  })))
}

resource "aws_subnet" "vpc01-sbn-priv-02" {
  vpc_id = aws_vpc.vpc01.id
  availability_zone = data.aws_availability_zones.all.name[2]
  cidr_block = "10.10.10.192/26"
  tags = (merge(local.common-tags, tomap ({
    Name = "vpc01-priv02-sbn"
    resource = "aws_subnet"
  })))
}

resource "aws_subnet" "vpc02-sbn-pub-01" {
  vpc_id = aws_vpc.vpc02.id
  availability_zone = data.aws_availability_zones.all.name[0]
  cidr_block = "10.10.20.0/26"
  tags = (merge(local.common-tags, tomap ({
    Name = "vpc02-pub01-sbn"
    resource = "aws_subnet"
  })))
}

resource "aws_subnet" "vpc02-sbn-pub-02" {
  vpc_id = aws_vpc.vpc02.id
  availability_zone = data.aws_availability_zones.all.name[2]
  cidr_block = "10.10.20.64/26"
  tags = (merge(local.common-tags, tomap ({
    Name = "vpc02-pub02-sbn"
    resource = "aws_subnet"
  })))
}

resource "aws_subnet" "vpc02-sbn-priv-01" {
  vpc_id = aws_vpc.vpc02.id
  availability_zone = data.aws_availability_zones.all.name[0]
  cidr_block = "10.10.20.128/26"
  tags = (merge(local.common-tags, tomap ({
    Name = "vpc02-priv01-sbn"
    resource = "aws_subnet"
  })))
}

resource "aws_subnet" "vpc02-sbn-priv-02" {
  vpc_id = aws_vpc.vpc02.id
  availability_zone = data.aws_availability_zones.all.name[2]
  cidr_block = "10.10.20.192/26"
  tags = (merge(local.common-tags, tomap ({
    Name = "vpc02-priv02-sbn"
    resource = "aws_subnet"
  })))
}