module "components" {
    for_each = var.component
    source = "../../terraform-roboshop-module"
    component = each.key
    priority = each.value.rule_priority
}
