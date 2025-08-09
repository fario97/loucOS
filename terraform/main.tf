terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# VPC/Subred por defecto
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# EC2 Instance

resource "aws_instance" "this" {
  ami           = var.ami_type # Amazon Linux 2023
  instance_type = var.instance_type
  subnet_id     = data.aws_subnets.default.ids[0]

  security_groups = [var.security_group_description]

  tags = {
    Name = "testing-loucOS-Instance"
  }
}