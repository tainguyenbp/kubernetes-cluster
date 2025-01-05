resource "aws_vpc" "main" {
    cidr_block = "172.31.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Environment = "Dev"
        Name = "vpc-dev"
    }
}

resource "aws_subnet" "private_subnet_1a_rds_dev" {
    vpc_id = aws_vpc.main.id
    cidr_block = "172.31.0.0/24"
    tags = {
        Name = "private-subnet-1a-rds-dev"
    }
}
