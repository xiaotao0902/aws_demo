variable "aws_region" {
  type    = "string"
  default = "ap-northeast-1"
}

variable "aws_profile" {
  type    = "string"
  default = "default"
}

variable "vpc_name" {
  description = "vpc-gitlab"
}

variable "cidr_block_vpc" {
  default = "10.100.0.0/16"
}

variable "cidr_block_public_subnet" {
  type    = "list"
  default = ["10.100.0.0/24", "10.100.2.0/24"]
 
}

variable "cidr_block_private_subnet" {
  type    = "list"
  default = ["10.100.1.0/24", "10.100.3.0/24"]
}

variable "db_instance_class" {
  default = "db.t2.medium"
}

variable "db_name" {
  default = "gitlabhq_production"
}

variable "db_username" {
  default = "usergitlab"
}

variable "db_password" {
  default = "passwordgitlab"
}

variable "db_multi_az" {
  default = true
}

variable "gitlab_image_id" {
  default = "ami-014e0ffcae71ba50a"
}

variable "gitlab_instance_type" {
  default = "t2.medium"
}

variable "gitlab_key_name" {
  default = "bastion-terraform"
}

variable "gitlab_ag_max_size" {
  default = 0
}

variable "gitlab_ag_min_size" {
  default = 0
}
  
variable "jenkins_ami" {
  default = "ami-0d7ed3ddb85b521a6"
}

variable "jenkins_instance_type" {
  default = "t2.micro"
}
variable "jenkins_key_name" {
  default = "bastion-terraform"
}

variable "bastion_ami" {
  default = "ami-0d7ed3ddb85b521a6"
}

variable "bastion_instance_type" {
  default = "t2.micro"
}

variable "bastion_key_name" {
  default = "bastion-terraform"
}
