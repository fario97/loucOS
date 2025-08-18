variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "eu-west-1"
}

variable "instance_type" {
  description = "The type of EC2 instance to create"
  type        = string
  default     = "t2.micro"
}

variable "security_group_description" {
  description = "Default security group"
  type        = string
  default     = "sg-06d99ad57f500499d"
}

variable "ami_type" {
  description = "The AMI type to use for the EC2 instance"
  type        = string
  default     = "ami-01f23391a59163da9" #~Ubuntu 24.04 EU
}

variable "root_volume_size_gib" {
  description = "Tamaño EBS"
  type        = number
  default     = 10
}

variable "allowed_ssh_cidr" {
  description = "CIDR autorizado para SSH, por ejemplo 203.0.113.4/32"
  default     = "81.61.49.25/32"
  type        = string
}

variable "tags" {
  description = "Etiquetas adicionales"
  type        = map(string)
  default     = {}
}


variable "key_name" {
  description = "Nombre de la clave SSH para acceder a la instancia"
  type        = string
  default     = "my-ec2"
}