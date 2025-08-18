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

resource "aws_default_security_group" "web" {
  vpc_id = data.aws_vpc.default.id

    lifecycle {
    prevent_destroy = true
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

    ingress {
    description = "Jenkins UI"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(var.tags, {
    Name = "default-sg (managed by Terraform)"
  })
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# EC2 Instance
resource "aws_instance" "jenkins" {
  ami           = var.ami_type
  instance_type = var.instance_type
  subnet_id     = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_default_security_group.web.id]
  key_name      = var.key_name
    # EBS
  root_block_device {
    volume_size = var.root_volume_size_gib
    volume_type = "gp3"
    encrypted   = true
  }

  
    # Configuración inicial
  user_data = <<-EOT
    #!/bin/bash
  sudo apt update -y
  sudo apt install openjdk-11-jdk -y
  wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
  echo "deb http://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list
  sudo apt update -y
  sudo apt install jenkins -y
  sudo systemctl start jenkins
  sudo systemctl enable jenkins
  sudo ufw allow 8080/tcp
  # for i in $(seq 1 120); do
  # if [ -s /var/lib/jenkins/secrets/initialAdminPassword ]; then
  #   PASS=$(cat /var/lib/jenkins/secrets/initialAdminPassword)
  #   # 1) Imprime al console output (visible con AWS CLI o en la consola EC2)
  #   echo "JENKINS_INITIAL_ADMIN_PASSWORD=$PASS" > /dev/console
  #   break
  #   fi
  #   sleep 5
  #   done
  EOT

  tags = {
    Name = "testing-loucOS-Instance"
  }


}
