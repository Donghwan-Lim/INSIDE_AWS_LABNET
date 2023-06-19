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