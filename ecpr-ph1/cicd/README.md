# ecpr-ph1 CI/CD

terraform script to deploy CI/CD env (gitlab web server,jenkins)

### infrastructure image
![infrastructure image][infraimage]

### var list
| var name                 |type     |default value                     |Description                       |
| -------------------------|---------|----------------------------------|----------------------------------|
| aws_profile              |String   |"default"                         |aws config                        |
| aws_region               |String   |"ap-northeast-1"                  |regin will be used                |
| vpc_name                 |String   |"vpc-gitlab"                      |name of vpc                       |
| cidr_block_vpc           |String   |"10.100.0.0/16"                   |CIDR BLOCK of vpc                 |
| cidr_block_public_subnet |String   |["10.100.0.0/24", "10.100.2.0/24"]|CIDR BLOCK of public subnet       |
| cidr_block_private_subnet|String   |["10.100.1.0/24", "10.100.3.0/24"]|CIDR BLOCK of private subnet      |
| db_instance_class        |String   |"db.t2.medium"                    |instance type of database         |
| db_name                  |String   |"gitlabhq_production"             |name of gitlab database           |
| db_username              |String   |"userGitlab"                      |user name of gitlab database      |
| db_password              |String   |"passwordGitlab"                  |password of gitlab database       |
| db_multi_az              |bool     |true                              |                                  |
| gitlab_image_id          |String   |"ami-014e0ffcae71ba50a"           |gitlab web server ami id(offical) |
| gitlab_instance_type     |String   |"t2.medium"                       |instance type of gitlab web server, at least t2.medium |
| gitlab_key_name          |String   |"bastion-terraform"               |key name of gitlab web server EC2 instance|
| gitlab_ag_max_size       |number   |1                                 |                                  |
| gitlab_ag_min_size       |number   |1                                 |                                  |
| gitlab_email_from        |String   |"jian.sun1@pactera.com"           |mail address be used for gitlab   |
| jenkins_ami              |String   |"ami-05cd6c87a37390178"           |amiID of jenkins server           |
| jenkins_instance_type    |String   |"t2.micro"                        |instance type of jenkins server   |
| jenkins_key_name         |String   |"bastion-terraform"               |key name of jenkins server EC2 instance|
| bastion_ami              |String   |"ami-05cd6c87a37390178"           |bastion web server ami id         |
| bastion_instance_type    |String   |"t2.micro"                        |instance type of bastion server   |
| bastion_key_name         |String   |"bastion-terraform"               |key name of bastion EC2 instance  |
                            
### deploy                             
terraform apply
terraform output "gitlab-serverspec" > ./serverspec/gitlab.yml

 

serverspec-runner -s gitlab.yml








[infraimage]:data:image/png;base64,---------

