# SECURITY GROUP CLUSTER MASTER
resource "aws_security_group" "security-group-eks-master" {
	name = "security-group-eks-master"
  
	tags {
		Name	= "security-group-eks-master"
	}

	vpc_id	= "${aws_vpc.DEV-EC-Platform-VPC.id}"

	ingress {
		from_port	= 443
		to_port		= 443
		protocol	= "tcp"
		cidr_blocks	= ["0.0.0.0/0"]
	}

	egress {
		from_port	= 1025
		to_port		= 65535
		protocol	= "tcp"
		cidr_blocks	= ["0.0.0.0/0"]
	}
}

#SECURITY GROUP CLUSTER NODE
resource "aws_security_group" "security-group-eks-node" {
	name = "security-group-eks-node"

	tags {
		Name	= "security-group-eks-mode"
	}

	vpc_id	="${aws_vpc.DEV-EC-Platform-VPC.id}"

	ingress {
		description	= "ingress for control plane"
		from_port	= 1025
		to_port		= 65535
		protocol	= "tcp"

		security_groups =[
			"${aws_security_group.security-group-eks-master.id}"
		]
	}

	ingress {
		description	= "inter worker nodes communication"
		from_port	= 0
		to_port		= 0
		protocol	= "-1"
		self		= true
	}

	egress {
		from_port	= 0
		to_port		= 0
		protocol	= "-1"
		cidr_blocks	= ["0.0.0.0/0"]
	}
}

#SECURITY GROUP SSM_BASTION
resource "aws_security_group" "security-group-ssm-public" {
  name   = "security-group-ssm-public"
  vpc_id = "${aws_vpc.DEV-EC-Platform-VPC.id}"
  tags {
    Name = "security-group-ssm-public"
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

resource "aws_security_group" "security-group-ec-db" {
  name   = "security-group-ec-db"
  vpc_id = "${aws_vpc.DEV-EC-Platform-VPC.id}"
  tags {
    Name = "security-group-ec-db"
  }
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
	security_groups = ["${aws_security_group.security-group-eks-master.id}","${aws_security_group.security-group-eks-node.id}"]
  }
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "security-group-ec-cache" {
  name   = "security-group-ec-cache"
  vpc_id = "${aws_vpc.DEV-EC-Platform-VPC.id}"
  tags {
    Name = "security-group-ec-cache"
  }
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
	security_groups = ["${aws_security_group.security-group-eks-master.id}","${aws_security_group.security-group-eks-node.id}"]
  }
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}