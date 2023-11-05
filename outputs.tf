output "vpc-id" {
    value = aws_vpc.my-app-vpc.id
}

output "subnet-id" {
    value = aws_subnet.my-app-subnet.id
}

output "aws-ami-id" {
    value = data.aws_ami.latest-amazon-linux-image.id
}

output "ec2_public_ip" {
  value = aws_instance.myapp-server.public_ip
}