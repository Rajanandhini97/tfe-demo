variable "vpc_cidr_block" {
    description = "VPC CIDR block"
}

variable "subnet_cidr_block" {
    description = "Subnet CIDR block"
    default = "10.0.0.0/24"
}

variable "environment" {
    description = "Environment name"
    type = list(object({
        env_name = string
        subscription = string
    }))
}