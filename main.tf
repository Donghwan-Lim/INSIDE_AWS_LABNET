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

### AWS VPC ###
resource "aws_vpc" "vpc01" {
  cidr_block = "10.10.10.0/24"
  tags = (merge(local.common-tags, tomap({
    Name = "vpc01"
    resource = "aws_vpc"
  })))
}

resource "aws_vpc" "vpc02" {
  cidr_block = "10.10.20.0/24"
  tags = (merge(local.common-tags, tomap({
    Name = "vpc02"
    resource = "aws_vpc"
  })))
}


