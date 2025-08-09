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
  default     = "ami-020cba7c55df1f615" # Example: Amazon Linux 2023
}