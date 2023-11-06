output "vpc01_id" {
  value       = aws_vpc.vpc01.id
  description = "INSIDE_AWS_LABNET_VPC_01_ID(10.10.10.0/24)"
}

output "vpc02_id" {
  value       = aws_vpc.vpc02.id
  description = "INSIDE_AWS_LABNET_VPC_02_ID(10.10.20.0/24)"
}

output "vpc01_public_subnet_01_id" {
  value       = aws_subnet.vpc01-sbn-pub-01.id
  description = "INSIDE_AWS_LABNET_VPC_01_SUBNET_PUBLIC_01_ID(10.10.10.0/26)"
}

output "vpc01_public_subnet_02_id" {
  value       = aws_subnet.vpc01-sbn-pub-02.id
  description = "INSIDE_AWS_LABNET_VPC_01_SUBNET_PUBLIC_02_ID(10.10.10.64/26)"
}
/*
output "vpc01_private_subnet_01_id" {
  value       = aws_subnet.vpc01-sbn-priv-01.id
  description = "INSIDE_AWS_LABNET_VPC_01_SUBNET_PRIVATE_01_ID(10.10.10.128/26)"
}

output "vpc01_private_subnet_02_id" {
  value       = aws_subnet.vpc01-sbn-priv-02.id
  description = "INSIDE_AWS_LABNET_VPC_01_SUBNET_PRIVATE_02_ID(10.10.10.192/26)"
}

output "vpc02_public_subnet_01_id" {
  value       = aws_subnet.vpc02-sbn-pub-01.id
  description = "INSIDE_AWS_LABNET_VPC_02_SUBNET_PUBLIC_01_ID(10.10.20.0/26)"
}

output "vpc02_public_subnet_02_id" {
  value       = aws_subnet.vpc02-sbn-pub-02.id
  description = "INSIDE_AWS_LABNET_VPC_02_SUBNET_PUBLIC_02_ID(10.10.20.64/26)"
}
*/
output "vpc02_private_subnet_01_id" {
  value       = aws_subnet.vpc02-sbn-priv-01.id
  description = "INSIDE_AWS_LABNET_VPC_02_SUBNET_PRIVATE_01_ID(10.10.20.128/26)"
}

output "vpc02_private_subnet_02_id" {
  value       = aws_subnet.vpc02-sbn-priv-02.id
  description = "INSIDE_AWS_LABNET_VPC_02_SUBNET_PRIVATE_02_ID(10.10.20.192/26)"
}

output "transit_gateway_01_id" {
  value       = aws_ec2_transit_gateway.tgw01.id
  description = "INSIDE_AWS_LABNET_TRANSIT GATEWAY BETWEEN VPC01 TO VPC02"
}