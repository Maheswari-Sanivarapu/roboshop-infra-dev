module "frontend" {
    #source = "../../terraform-aws-security-group-module"
    source = "git::https://github.com/mahi2298/terraform-aws-security-group-module.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = var.frontend_sg_name
    sg_description = var.frontend_sg_description
    vpc_id = local.vpc_id # retrieving the vpc id using data source and calling that value here
}

output "sg_id" {
    value = module.frontend.sg_id # here .sg_id is exposed from output of terraform-aws-security-group-module
}