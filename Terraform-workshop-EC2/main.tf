
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

resource "aws_instance" "app_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name = var.key_pair
  associate_public_ip_address = true
  security_groups = [var.sg_name]

  tags = {
    Name = "TFDeployInstance"
	Type = "TFDeploy"
  }
}                                                                           

resource "aws_security_group" "instance_sg" {
  name = var.sg_name
  description = var.sg_desc
  vpc_id  = var.vpc_ID
  
  ingress {
    cidr_blocks = var.all_blocks
    description = "Acceso al puerto 80 desde el exterior"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  } 
  ingress {
    cidr_blocks = var.all_blocks
    description = "Acceso al puerto 443 desde el exterior"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }  
  ingress {
    cidr_blocks = var.single_ips
    description = "Acceso administrativo por ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  egress {
    cidr_blocks = var.all_blocks
    description = "Salida a internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
  
  tags = {
	Type = "TFDeploy"
  }
}                                                                 
