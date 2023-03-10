module "ec2" {
  source               = "./ec2"
  ami                  = var.ami
  instance_type        = var.instance_type
  key_name             = var.key_name
  subnet_id            = var.subnet_id
  iam_instance_profile = var.iam_instance_profile
  bucket_url           = var.bucket_url
  security_groups      = var.security_groups
  ebs_att_device_name  = var.ebs_att_device_name
  availability_zone    = var.availability_zone
  ebs_volume_size      = var.ebs_volume_size
  env                  = var.env
  tags = {
    Name        = var.user_name
    user_name   = var.user_name
    jira_ticket = "${var.jira_url}${var.ticket_number}"
  }
}

resource "null_resource" "vm" {
  connection {
    host        = module.ec2.instance_ip
    type        = "ssh"
    user        = "ubuntu"
    timeout     = "2m"
    private_key = file("test.pem")
  }
  provisioner "file" {
    source      = "ansible/"
    destination = "/home/ubuntu/ansible/"
  }
  provisioner "remote-exec" {
    inline = [
      "ansible-playbook /home/ubuntu/ansible/playbooks/corporate.yml"
    ]
  }
}
