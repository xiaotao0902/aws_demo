variable "aws_region" {
	default	="ap-northeast-1"
}

variable "aws_profile" {
	type	= "string"
	default	= "default"
}

variable "eks_worker_image" {
	type	= "string"
}

variable "eks_worker_instance_type" {
	type	= "string"
	default	= "t2.small"
}

variable "eks_worker_key" {
	type	= "string"
	default	= "eks-worker-key"
}

variable "public_subnet" {
	type	= "list"
	default	= ["192.168.1.0/24","192.168.2.0/24","192.168.3.0/24"]
}

variable "private_subnet" {
	type	= "list"
	default	= ["192.168.4.0/24","192.168.5.0/24","192.168.6.0/24"]
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

variable "aws_account" {
  default = "next-era"
}

variable "db_instance_class" {
  default = "db.t2.medium"
}

variable "db_name" {
  default = "ecplatform"
}

variable "db_username" {
  default = "ecplateform"
}

variable "db_password" {
  default = "password"
}

variable "db_multi_az" {
  default = true
}

variable "cluster_engine" {
  default = "redis"
}

variable "cluster_node_type" {
  default = "cache.t2.micro"
}

variable "cluster_num_cache_nodes" {
  default = "1"
}

variable "cluster_parameter_group_name" {
  default = "default.redis3.2"
}

variable "cluster_engine_version" {
  default = "3.2.10"
}

variable "cluster_port" {
  default = "6379"
}