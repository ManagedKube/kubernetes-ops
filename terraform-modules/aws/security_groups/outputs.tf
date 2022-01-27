output "security_group_id_list" {
  value = aws_security_group.sg.*.id
}

output "security_group_arn_list" {
  value = aws_security_group.sg.*.arn
}

output "security_group_name_list" {
  value = aws_security_group.sg.*.name
}

output "sg_list" {
  value = {
    name = aws_security_group.sg[*].name
    id   = aws_security_group.sg[*].id
  }
}
