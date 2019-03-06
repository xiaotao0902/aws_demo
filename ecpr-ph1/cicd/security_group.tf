###############################
#セキュリティグループ                #
###############################

#パブリックセキュリティグループ 
resource "aws_security_group" "security-group-gitlab-public" {
  name   = "security-group-gitlab-public"
  vpc_id = "${aws_vpc.vpc-gitlab.id}"
  tags {
    Name = "security-group-gitlab-public"
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#giblab app serverセキュリティグループ 
resource "aws_security_group" "security-group-gitlab-apl" {
  name   = "security-group-gitlab-apl"
  vpc_id = "${aws_vpc.vpc-gitlab.id}"
  tags {
    Name = "security-group-gitlab-apl"
  }
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
	security_groups = ["${aws_security_group.security-group-gitlab-public.id}"]
  }
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }  
}

#giblab DB serverセキュリティグループ 
resource "aws_security_group" "security-group-gitlab-db" {
  name   = "security-group-gitlab-db"
  vpc_id = "${aws_vpc.vpc-gitlab.id}"
  tags {
    Name = "security-group-gitlab-db"
  }
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
	security_groups = ["${aws_security_group.security-group-gitlab-public.id}","${aws_security_group.security-group-gitlab-apl.id}"]
  }
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
