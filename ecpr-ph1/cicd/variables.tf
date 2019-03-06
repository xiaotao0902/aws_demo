###############################
#変数定義                     #
###############################

#
variable "aws_region" {
  type    = "string"
  default = "ap-northeast-1"
}

variable "aws_profile" {
  type    = "string"
  default = "default"
}

#VPC名
variable "vpc_name" {
  type        = "string"
  description = "vpc-gitlab"
}

#VPCのCIDRブロック
variable "cidr_block_vpc" {
  type        = "string"
  default = "10.100.0.0/16"
}

#パブリックサブネットCIDRブロック
variable "cidr_block_public_subnet" {
  type    = "list"
  default = ["10.100.0.0/24", "10.100.2.0/24"]
 
}

#プライベートサブネットCIDRブロック
variable "cidr_block_private_subnet" {
  type    = "list"
  default = ["10.100.1.0/24", "10.100.3.0/24"]
}

#DB インスタンスのクラス
variable "db_instance_class" {
  default = "db.t2.medium"
}

#DB インスタンス識別子
variable "db_name" {
  default = "gitlabhq_production"
}

#マスターユーザの名前
variable "db_username" {
  default = "usergitlab"
}

#マスターパスワード
variable "db_password" {
  default = "passwordgitlab"
}

#マルチ AZ 配置
variable "db_multi_az" {
  default = true
}

#GitLabマシンイメージID
variable "gitlab_image_id" {
  default = "ami-014e0ffcae71ba50a"
}

#GitLabインスタンスタイプ
variable "gitlab_instance_type" {
  default = "t2.medium"
}

#GitLabキーペア名
variable "gitlab_key_name" {
  default = "bastion-terraform"
}

#インスタンスの最大数
variable "gitlab_ag_max_size" {
  default = 0
}

#インスタンスの最小数
variable "gitlab_ag_min_size" {
  default = 0
}

#
variable "gitlab_email_from" {
  default = "jian.sun1@pactera.com"
}
 
#jenkinsマシンイメージID  
variable "jenkins_ami" {
  default = "ami-0d7ed3ddb85b521a6"
}

#jenkinsインスタンスタイプ
variable "jenkins_instance_type" {
  default = "t2.micro"
}

#jenkinsキーペア名
variable "jenkins_key_name" {
  default = "bastion-terraform"
}

#踏み台マシンイメージID
variable "bastion_ami" {
  default = "ami-0d7ed3ddb85b521a6"
}

#踏み台インスタンスタイプ
variable "bastion_instance_type" {
  default = "t2.micro"
}

#踏み台キーペア名
variable "bastion_key_name" {
  default = "bastion-terraform"
}
