terraform {
  backend "s3" {
  }
}

resource "aws_iam_user_policy_attachment" "attach" {
  count      = length(var.user_list)
  user       = var.user_list[count.index]
  policy_arn = var.policy_arn
}
