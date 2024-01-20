# Module 12 - Infrastructure as Code with Terraform

## Demo Project: Automate AWS EC2 Infrastructure Provisioning - Terraform

This project utilizes terraform to create EC2 instance. The deployment included the following AWS  resources:

+ VPC (Internet Gateway attached) and a subnet that utilizes default route table and Security Group
+ Security group inbound rule configured to allow SSH port access at 22 from user's ip only.
+ Security group inbound rule configured to open access to port 8080 for ngnix.
+ EC2 instance using latest amazon linux AMI and existing key-pair with public ip enabled.
+ A shell script that runs executes on EC2 to install docker and start nginx.

### Prerequisites

This deployment also requires the following resources to be referenced:

+ Existing EC2 Key Pair location.
+ AWS provider version >=5.24.0

### Inputs

| Name                | Description                                             |
|---------------------|---------------------------------------------------------|
| vpc_cidr_block      | ipv4 address (ex: 10.0.0.0/16)                          |
| subnet_cidr_block   | ipv4 address                                            |
| availability_zone   | Availability zone                                       |
| env_prefix          | environment that will be prefixed for resource tag name |
| my_ip               | Your ipv4 address                                       |
| instance_type       | instance size based on cpu memory (ex: t2.micro)        |
| public_key_location | Absolute path to your ssh public key                    |
| image_name          | ami name (can be found on AWS UI)                       |

### Outputs

| Name               | Description                             |
|--------------------|-----------------------------------------|
| vpc-id             | VPC ID                                  |
| subnet-id          | Subnet ID                               |
| aws-ami-id         | AMI id used queried by datasource block |
| ec2_public_ip      | EC2 public ip address                   |

### Deployments using tf files on branch feature/deploy-ec2

1. Plan and apply 
```
terraform init
terraform plan -var-file terraform.tfvars

terraform apply -var-file terraform.tfvars
```
2. Access NGINX on {ec2-public-ip}:8080
3. Destroy ```terraform destroy```

### Deployments using tf files on branch feature/provisioners

This branch introduces and demonstrates about using provisioners block

Type of provisioners used:

+ file - to copy script file from local to remote
```
 provisioner "file" {
    source = "entry-script.sh"
    destination = "/home/ec2-user/script.sh"
  }
```
+ local-exec - invoked local execution where terraform is running
```
provisioner "local-exec" {
    command = "echo ${self.public_ip} > output.txt"
  }
```
+ remote-exec - to run the script copied over on the remote resource after it is created.
```
provisioner "remote-exec" {
    script = file("script.sh")
  }
```
To deploy run the same commands as from previous section.

### Deployments using tf files on branch feature/modules

This introduces the modules concept with two modules subnet and webserver.
+ The subnet module creates a subnet inside an existing VPC.
+ The webserver module creates an EC2 instance in this subnet and VPC by calling both the modules on parent main.tf

To deploy run the same commands as from feature/deploy-ec2 section.