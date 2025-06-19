resource "aws_instance" "this" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [var.sg_id]
  associate_public_ip_address = false  # Ensure private-only
  key_name               = var.key_name

  tags = {
    Name = "three-tier-app"
  }

  # Optional user_data for placeholder setup (commented for now)
  # user_data = <<-EOF
  # #!/bin/bash
  # yum update -y
  # yum install -y httpd
  # systemctl start httpd
  # EOF
}

