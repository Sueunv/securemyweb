resource "aws_instance" "this" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [var.sg_id]
  user_data     = var.user_data
  key_name = "gitkey"

  tags = {
    Name = "three-tier-web"
  }
}

