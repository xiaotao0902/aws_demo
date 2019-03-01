resource "aws_db_subnet_group" "db-subnet-group-eks" {
  name       = "db-subnet-group-eks"
  subnet_ids = ["${aws_subnet.public.*.id}"]
  tags = {
    Name = "subnet-group-eks"
  }
}

resource "aws_db_parameter_group" "db-parameter-group-eks" {
  name   = "db-parameter-group-eks"
  family = "postgres9.6"
}

resource "aws_db_option_group" "db-option-group-eks" {
  name                     = "db-option-group-eks"
  option_group_description = "db-option-group-eks"
  engine_name              = "postgres"
  major_engine_version     = "9.6"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_instance" "db-postgres-eks" {
  identifier = "pg-eks"
  allocated_storage      = 10
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "9.6"
  instance_class         = "${var.db_instance_class}"
  name                   = "${var.db_name}"
  username               = "${var.db_username}"
  password               = "${var.db_password}"
  parameter_group_name   = "${aws_db_parameter_group.db-parameter-group-eks.id}"
  db_subnet_group_name   = "${aws_db_subnet_group.db-subnet-group-eks.id}"
  option_group_name      = "${aws_db_option_group.db-option-group-eks.id}"
  vpc_security_group_ids = ["${aws_security_group.security-group-ec-db.id}"]
  skip_final_snapshot    = true
  multi_az               = "${var.db_multi_az}"
  apply_immediately      = true
}
