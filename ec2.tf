#resource block
resource "aws_instance" "ubuntu" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.my_instance_type
  #user_data     = file("${path.module}/ansible-install-ubuntu.sh")
  user_data = data.template_cloudinit_config.user-data.rendered

  key_name = var.jenkins-key

  tags = {
    "Name" = "Jenkins-end-to-end"
  }
}


data "template_cloudinit_config" "user-data" {
  part {
    content_type = "text/x-shellscript"
    content      = file("${path.module}/jenkins-install-ubuntu.sh")
  }
  part {
    content_type = "text/x-shellscript"
    content      = file("${path.module}/vscode-install.sh")
  }
}
