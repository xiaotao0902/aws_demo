###############################
#Auto Scaling グループ          #
###############################

#ターゲットグループ
resource "aws_lb_target_group" "lb-target-group-gitlab" {
    name                 = "lb-target-group-gitlab"
    port                 = "80"
    protocol             = "HTTP"
    vpc_id               = "${aws_vpc.vpc-gitlab.id}"
	target_type          = "instance"
    deregistration_delay = 300
    tags {
        Name             = "lb-target-group-gitlab"
    }
}

#ロードバランサー
resource "aws_lb" "lb-gitlab" {
  name                       = "lb-gitlab"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = ["${aws_security_group.security-group-gitlab-public.id}"]
  subnets                    = ["${aws_subnet.subnet-gitlab-public.*.id}"]
  ip_address_type            = "ipv4"
  enable_deletion_protection = false
  tags = {
    name = "lb-gitlab"
  }
}

#リスナー
resource "aws_lb_listener" "lb-listener-gitlab" {
  load_balancer_arn  = "${aws_lb.lb-gitlab.arn}"
  port               = "80"
  protocol           = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.lb-target-group-gitlab.arn}"
  }
}

#起動設定の作成 
resource "aws_launch_configuration" "launch-configuration-gitlab" {
  name_prefix      = "launch-configuration-gitlab-"
  image_id         = "${var.gitlab_image_id}"
  instance_type    = "${var.gitlab_instance_type}"
  key_name         = "${var.gitlab_key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.ssm-role-gitlab-profile.name}"
  security_groups = ["${aws_security_group.security-group-gitlab-apl.id}"]
  lifecycle {
    ignore_changes = ["private_ip", "root_block_device", "ebs_block_device"]
	create_before_destroy = true
  }
  user_data        = <<USERDATA
#!/bin/bash
sudo chmod 777 /etc/gitlab/gitlab.rb
sudo echo "#DATABASE" > /etc/gitlab/gitlab.rb
sudo echo "external_url 'http://${aws_lb.lb-gitlab.dns_name}'" >> /etc/gitlab/gitlab.rb
sudo echo "gitlab_rails['db_adapter'] = 'postgresql'" >> /etc/gitlab/gitlab.rb
sudo echo "gitlab_rails['db_encoding'] = 'unicode'" >> /etc/gitlab/gitlab.rb
sudo echo "gitlab_rails['db_database'] = '${aws_db_instance.db-postgres-gitlab.name}'" >> /etc/gitlab/gitlab.rb
sudo echo "gitlab_rails['db_pool'] = '10'" >> /etc/gitlab/gitlab.rb
sudo echo "gitlab_rails['db_username'] = '${aws_db_instance.db-postgres-gitlab.username}'" >> /etc/gitlab/gitlab.rb
sudo echo "gitlab_rails['db_password'] = '${var.db_password}'" >> /etc/gitlab/gitlab.rb
sudo echo "gitlab_rails['db_host'] = '${aws_db_instance.db-postgres-gitlab.address}'" >> /etc/gitlab/gitlab.rb
sudo echo "gitlab_rails['db_port'] = '5432'" >> /etc/gitlab/gitlab.rb
sudo echo "gitlab_rails['db_prepared_statements'] = 'false'" >> /etc/gitlab/gitlab.rb
sudo echo "gitlab_rails['db_statements_limit'] = '1000'" >> /etc/gitlab/gitlab.rb
sudo echo "gitlab_rails['gitlab_email_from'] = '${var.gitlab_email_from}'" >> /etc/gitlab/gitlab.rb
#sudo /opt/gitlab/embedded/bin/psql -U usergitlab -h ${aws_db_instance.db-postgres-gitlab.address} -d ${aws_db_instance.db-postgres-gitlab.name} -c "create extension pg_trgm;"
sudo gitlab-ctl reconfigure
sudo gitlab-ctl restart
  USERDATA
}

#Auto Scaling グループ
resource "aws_autoscaling_group" "autoscaling-group-gitlab" {
  name = "autoscaling-group-gitlab"
  launch_configuration    = "${aws_launch_configuration.launch-configuration-gitlab.name}"
  vpc_zone_identifier     = ["${aws_subnet.subnet-gitlab-private.*.id}"]
  max_size                = "${var.gitlab_ag_max_size}"
  min_size                = "${var.gitlab_ag_min_size}"
  health_check_type	      = "EC2"
  target_group_arns       = ["${aws_lb_target_group.lb-target-group-gitlab.arn}"]
  lifecycle {
    create_before_destroy = true
  }
}



