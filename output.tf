output "vpc01_id" {
    value = aws_vpc.vpc01.id
    description = "INSIDE_AWS_LABNET_VPC_01_ID(10.10.10.0/24)"
}

output "vpc02_id" {
    value = aws_vpc.vpc02.id
    description = "INSIDE_AWS_LABNET_VPC_02_ID(10.10.20.0/24)"
}