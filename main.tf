module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
  azs = ["us-east-1a", "us-east-1b"]
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP from internet"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP from ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "web" {
  source = "./modules/web"
  ami_id = "ami-09e6f87a47903347c" # Use a valid Ubuntu AMI ID for us-east-1
  instance_type = "t2.micro"
  subnet_id = module.vpc.public_subnet_ids[0]
  sg_id = aws_security_group.web_sg.id
#  user_data = file("web_user_data.sh")
}

module "alb" {
  source = "./modules/alb"
  subnet_ids = module.vpc.public_subnet_ids
  vpc_id = module.vpc.vpc_id
  alb_sg_id = aws_security_group.alb_sg.id
  web_instance_id = module.web.instance_id
}



resource "aws_security_group" "app_sg" {
  name        = "app-sg"
  description = "Allow traffic from Web EC2"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  ingress {
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  security_groups = [aws_security_group.web_sg.id]
}


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


module "app" {
  source = "./modules/app"
  ami_id = "ami-09e6f87a47903347c"  # Same as Web EC2 — ✅ safe
  instance_type = "t2.micro"
  subnet_id = module.vpc.private_subnet_ids[0]
  sg_id = aws_security_group.app_sg.id
  key_name      = "gitkey"
}

module "s3_diagrams" {
  source = "./modules/s3_diagrams"
}


module "rds" {
  source              = "./modules/rds"
  private_subnet_ids  = module.vpc.private_subnet_ids
  db_username         = "adminuser"
  db_password         = "SuperSecret123!"    # Consider using AWS Secrets Manager or TF vars
  app_sg_id           = aws_security_group.app_sg.id
}


