provider "aws" {
    region = "us-east-1"
}

resource "aws_vpc" "my-app-vpc" {
    cidr_block = var.vpc_cidr_block
    
    tags = {
        Name: "${var.env_prefix}-vpc"
    }
}
module "myapp-subnet" {
  source = "./modules/subnets"

  subnet_cidr_block = var.subnet_cidr_block
  availability_zone = var.availability_zone
  env_prefix = var.env_prefix
  vpc_id = aws_vpc.my-app-vpc.id
  default_route_table_id = aws_vpc.my-app-vpc.default_route_table_id
}

module "myapp-server" {
  source = "./modules/webserver"

  vpc_id = aws_vpc.my-app-vpc.id
  my_ip = var.my_ip
  env_prefix = var.env_prefix
  image_name = var.image_name
  public_key_location = var.public_key_location
  instance_type = var.instance_type
  subnet_id = module.myapp-subnet.subnet.id
  availability_zone = var.availability_zone
}
