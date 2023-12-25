provider "aws" {
    region = "us-east-1"
}

resource "aws_vpc" "my-app-vpc" {
    cidr_block = var.vpc_cidr_block
    
    tags = {
        Name: "${var.env_prefix}-vpc"
    }
}

resource "aws_subnet" "my-app-subnet" {
    vpc_id = aws_vpc.my-app-vpc.id
    cidr_block = var.subnet_cidr_block
    availability_zone = var.availability_zone
    
    tags = {
        Name: "${var.env_prefix}-subnet"
    }
}

resource "aws_internet_gateway" "my-app-gw" {
  vpc_id = aws_vpc.my-app-vpc.id
  
  tags = {
    Name = "${var.env_prefix}-igw"
  }
}

# resource "aws_route_table" "my-app-route-table" {
#     vpc_id = aws_vpc.my-app-vpc.id

#     route {
#         cidr_block = "0.0.0.0/0"
#         gateway_id = aws_internet_gateway.my-app-gw.id
#     }
    
#     tags = {
#     Name = "${var.env_prefix}-route-table"
#     }
# }

# resource "aws_route_table_association" "a-rtb-subnet" {
#   subnet_id      = aws_subnet.my-app-subnet.id
#   route_table_id = aws_route_table.my-app-route-table.id
# }

resource "aws_default_route_table" "main-rtb" {
  default_route_table_id = aws_vpc.my-app-vpc. default_route_table_id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my-app-gw.id
    }

    tags = {
    Name = "${var.env_prefix}-main-rtb"
  }

}

resource "aws_default_security_group" "default-sg" {
  vpc_id      = aws_vpc.my-app-vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.my_ip]
  }

  ingress {
    description      = "TLS from VPC"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    prefix_list_ids  = []
  }

  tags = {
    Name = "${var.env_prefix}-default-sg"
  }
}

data "aws_ami" "latest-amazon-linux-image" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

resource "aws_key_pair" "ssh-key" {
  key_name   = "server-key"
  public_key = file(var.public_key_location)
}

resource "aws_instance" "myapp-server" {
  ami           = data.aws_ami.latest-amazon-linux-image.id
  instance_type = var.instance_type

  subnet_id = aws_subnet.my-app-subnet.id
  vpc_security_group_ids = [ aws_default_security_group.default-sg.id ]
  availability_zone = var.availability_zone

  associate_public_ip_address = true
  key_name = aws_key_pair.ssh-key.key_name

  user_data = file("entry-script.sh")

  tags = {
    Name = "${var.env_prefix}-server"
  }
}
