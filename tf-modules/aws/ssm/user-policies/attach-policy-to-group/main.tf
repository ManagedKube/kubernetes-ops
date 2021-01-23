terraform {
  backend "s3" {
  }
}

resource "aws_iam_group_policy_attachment" "attach" {
  count      = length(var.group_list)
  group      = var.group_list[count.index]
  policy_arn = var.policy_arn
}
