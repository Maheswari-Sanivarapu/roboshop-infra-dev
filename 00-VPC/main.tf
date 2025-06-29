module "vpc" {
    source = "git::https://github.com/mahi2298/terraform-aws-vpc-module.git?ref=main" # here storing the module in github instead of storing it in local
    project = var.project
    environment = var.environment
    public_subnet_cidr = var.public_subnet_cidr
    private_subnet_cidr = var.private_subnet_cidr
    database_private_subnet_cidr = var.database_subnet_cidr
    is_vpc_peering = true
}

# here we are storing this value in ssm parameter store i.e. in parameters.tf
output "vpc_id" {
    value = module.vpc.vpc_id  # here taking the vpc_id exposed from terraform-aws-vpc-module--> output.tf and calling it as vpc_id
}

output "public_subnet" {
    value = module.vpc.public_subnet_id # here taking the public_subnet_id exposed from terraform-aws-vpc-module--> output.tf and calling it as public_subnet_id
}

output "private_subnet" {
    value = module.vpc.private_subnet_id # here taking the private_subnet_id exposed from terraform-aws-vpc-module--> output.tf and calling it as private_subnet_id
}

output "database_subnet" {
    value = module.vpc.database_subnet_id # here taking the database_subnet_id exposed from terraform-aws-vpc-module--> output.tf and calling it as private_subnet_id
}
