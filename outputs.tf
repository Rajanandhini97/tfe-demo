output "vpc-id" {
    value = aws_vpc.dev-vpc.id
}

output "subnet-id" {
    value = aws_subnet.dev-subnet.id
}