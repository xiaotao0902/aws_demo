###############################
#rds-postgresql               #
###############################

#サブネットグループ
resource "aws_db_subnet_group" "db-subnet-group-gitlab" {
  name       = "db-subnet-group-gitlab"
  subnet_ids = ["${aws_subnet.subnet-gitlab-private.*.id}"]
  tags = {
    Name = "subnet-group-gitlab"
  }
}

#パラメータグループ 
resource "aws_db_parameter_group" "db-parameter-group-gitlab" {
  name   = "db-parameter-group-gitlab"
  family = "postgres10"
}

#オプショングループ 
resource "aws_db_option_group" "db-option-group-gitlab" {
  name                     = "db-option-group-gitlab"
  option_group_description = "db-option-group-gitlab"
  engine_name              = "postgres"
  major_engine_version     = "10"
  lifecycle {
    create_before_destroy = true
  }
}

#DB インスタンス
resource "aws_db_instance" "db-postgres-gitlab" {
  identifier = "pg-gitlab"
  allocated_storage      = 10
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "10"
  instance_class         = "${var.db_instance_class}"
  name                   = "${var.db_name}"
  username               = "${var.db_username}"
  password               = "${var.db_password}"
  parameter_group_name   = "${aws_db_parameter_group.db-parameter-group-gitlab.id}"
  db_subnet_group_name   = "${aws_db_subnet_group.db-subnet-group-gitlab.id}"
  option_group_name      = "${aws_db_option_group.db-option-group-gitlab.id}"
  vpc_security_group_ids = ["${aws_security_group.security-group-gitlab-db.id}"]
  skip_final_snapshot    = true
  multi_az               = "${var.db_multi_az}"
  apply_immediately      = true
}
