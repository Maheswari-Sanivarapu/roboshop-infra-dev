module "vpc" {
    source = "git::https://github.com/mahi2298/terraform-aws-vpc-module.git?ref=main"
    project = var.project
    environment = var.environment
    public_subnet_cidr = var.public_subnet_cidr
    private_subnet_cidr = var.private_subnet_cidr
    is_vpc_peering = true
}