aws_profile               = "default"
aws_region                = "ap-northeast-1"
vpc_name                  = "vpc-gitlab"
cidr_block_vpc            = "10.100.0.0/16"
cidr_block_public_subnet  = ["10.100.0.0/24", "10.100.2.0/24"]
cidr_block_private_subnet = ["10.100.1.0/24", "10.100.3.0/24"]

db_instance_class         = "db.t2.medium"
db_name                   = "gitlabhq_production"
db_username               = "userGitlab"
db_password               = "passwordGitlab"
db_multi_az               = true

gitlib_image_id           = "ami-014e0ffcae71ba50a"
gitlib_instance_type      = "t2.medium"
gitlib_key_name           = "bastion-terraform"
gitlib_ag_max_size        = 1
gitlib_ag_min_size        = 1
  
jenkins_ami               = "ami-05cd6c87a37390178"
jenkins_instance_type     = "t2.micro"
jenkins_key_name          = "bastion-terraform"

bastion_ami               = "ami-05cd6c87a37390178"
bastion_instance_type     = "t2.micro"
bastion_key_name          = "bastion-terraform"



