resource "aws_ram_principal_association" "this" {
  principal          = var.principal
  resource_share_arn = var.resource_share_arn

  # The invitation sometime takes a few seconds to propagate
  provisioner "local-exec" {
    command = "python3 -c 'import time; time.sleep(10)'"
  }
}
