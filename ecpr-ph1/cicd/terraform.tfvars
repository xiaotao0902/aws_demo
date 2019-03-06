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

gitlab_image_id           = "ami-014e0ffcae71ba50a"
gitlab_instance_type      = "t2.medium"
gitlab_key_name           = "gitlab_key"
gitlab_ag_max_size        = 1
gitlab_ag_min_size        = 1
gitlab_email_from         ="jian.sun1@pactera.com"
  
jenkins_ami               = "ami-05cd6c87a37390178"
jenkins_instance_type     = "t2.micro"
jenkins_key_name          = "gitlab_key"

bastion_ami               = "ami-05cd6c87a37390178"
bastion_instance_type     = "t2.micro"
bastion_key_name          = "gitlab_key"



