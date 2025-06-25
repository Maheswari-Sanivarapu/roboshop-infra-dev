locals {
    ami_id = data.aws_ami.ami_id.id
    bastion_sg_id = data.aws_ssm_parameter.bastion_sg_id.value
    public_subnet_id = split(",",data.aws_ssm_parameter.public_subnet_id.value)[0] # split function produces a list by dividing a given string at all occurrences of a given separator. 
     common_tags = {
        project = var.project
        environment = var.environment
    }
}