variable "aws_region" {
  description = "AWS region on which we will setup the swarm cluster"
  default = "eu-west-1"
}

variable "aws_az" {
  description = "AWS AZ on which we will setup the swarm cluster"
  type    = list(string)
  default = ["eu-west-1a","eu-west-1b"]
}

variable "worker_count" {
  description = "Number of worker nodes in the swarm cluster"
  default = "2"
}

variable "master_count" {
  description = "Number of master nodes in the swarm cluster ()"
  default = "1"
}

variable "ami" {
  description = "Amazon Linux 2 AMI"
  default = "ami-0ce71448843cb18a1"
}

variable "so_user" {
  description = "SO User in AMI"
  default = "ec2-user"
}

variable "instance_type" {
  description = "Instance type"
  default = "t2.micro"
}

variable "key_path" {
  description = "SSH Public Key path"
  default = "../../cert/id_rsa.pub"
}

variable "key_file" {
  description = "SSH Public Key path"
  default = "../../cert/id_rsa"
}

variable "bootstrap_path" {
  description = "Script to install Docker Engine"
  default = "./scripts/install-docker.sh"
}

variable "project_name" {
  description = "Proyect Name"
  default = "sandbox"
}
variable "domain" {
  description = "Domain"
  default = "chakray.cloud"
}

variable "ENVIRONMENT" {
  description = "Proyecto"
  default = "alpha"
}

variable "spot_instances" {
  description = "Use spot instances?"
  default = true
}

variable "spot_price" {
  description = "max spot price"
  default = 0.03
}
variable "create_rds_instance" {
  description = "Create RDS instance"
  default = false
}
variable "rds_type" {
  description = "RDS instance type"
  default = "db.t2.medium"
}

