module "vpc" {
    source = "git::https://github.com/mahi2298/terraform-aws-vpc-module.git?ref=main" # here storing the module in github instead of storing it in local
    project = var.project
    environment = var.environment
    public_subnet_cidr = var.public_subnet_cidr
    private_subnet_cidr = var.private_subnet_cidr
    is_vpc_peering = true
}

output "vpc_id" {
    value = module.vpc.vpc_id  # here taking the vpc_id exposed from terraform-aws-vpc-module--> output.tf and calling it as vpc_id
}