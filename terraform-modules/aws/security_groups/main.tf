// Create the list of all security groups
resource "aws_security_group" "sg" {
  count  = length(var.security_groups)
  name   = var.security_groups[count.index].name
  vpc_id = var.vpc_id
  tags   = merge(var.security_groups[count.index].tags, {Name=var.security_groups[count.index].name})
}

// loop through the security groups to create the security group rules
// pass source source security group id and name down
module "security_group_loop" {
  source = "./security_group_loop"

  count = length(aws_security_group.sg)

  source_security_group_id   = aws_security_group.sg[count.index].id
  source_security_group_name = var.security_groups[count.index].name

  security_group_list = aws_security_group.sg

  security_group_rule_list = var.security_groups[count.index].config

}
