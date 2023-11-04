provider "aws" {
    region = "us-east-1"
}

resource "aws_vpc" "dev-vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name: "dev-vpc"
        vpc_env: var.environment[0].env_name
        subscription: var.environment[0].subscription
    }
}

resource "aws_subnet" "dev-subnet" {
    vpc_id = aws_vpc.dev-vpc.id
    cidr_block = var.subnet_cidr_block
    availability_zone = "us-east-1a"
    tags = {
        Name: "dev-subnet-1"
    }
}

data "aws_vpc" "existing-vpc" {
    default = true
}

resource "aws_subnet" "dev-subnet-2" {
    vpc_id = data.aws_vpc.existing-vpc.id
    cidr_block = "172.31.96.0/20"
    availability_zone = "us-east-1a"
    tags = {
        Name: "dev-subnet-2"
    }
}
