

module "vpc_dev" {
    source = "./modules/vpc"
    cidr_block = "172.29.0.0/16"
    environment = "development"
}
module "vpc_prod" {
    source = "./modules/vpc"
    cidr_block = "172.31.0.0/16"
    environment = "production"
}
