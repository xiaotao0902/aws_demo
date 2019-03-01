data "aws_availability_zones" "available" {}

resource "aws_vpc" "vpc-gitlab" {
  cidr_block       = "${var.cidr_block_vpc}"
  instance_tenancy = "default"
  tags = {
    Name = "${var.vpc_name}"
  }
}

resource "aws_internet_gateway" "igw-gitlab" {
	vpc_id = "${aws_vpc.vpc-gitlab.id}"
	tags {
	Name = "igw-${var.vpc_name}"
	}
}

resource "aws_route_table" "rtl-gitlab-public" {
  vpc_id = "${aws_vpc.vpc-gitlab.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw-gitlab.id}"
  }
}

resource "aws_subnet" "subnet-gitlab-public" {
  count                   = "${length(var.cidr_block_public_subnet)}"
  vpc_id                  = "${aws_vpc.vpc-gitlab.id}"
  cidr_block              = "${var.cidr_block_public_subnet[count.index]}"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = true
  tags {
    Name = "subnet-gitlab-public"
  }
}

resource "aws_route_table_association" "rtl-gitlab-public" {
  count          = "${length(var.cidr_block_public_subnet)}"
  route_table_id = "${aws_route_table.rtl-gitlab-public.id}"
  subnet_id      = "${element(aws_subnet.subnet-gitlab-public.*.id, count.index)}"
}


resource "aws_eip" "eip-nat-gitlab" {
  vpc      = true
}

resource "aws_nat_gateway" "nat-gateway-gitlab" {
  allocation_id = "${aws_eip.eip-nat-gitlab.id}"
  subnet_id     = "${aws_subnet.subnet-gitlab-public.*.id[0]}"
}

resource "aws_route_table" "rtl-gitlab-private" {
  vpc_id = "${aws_vpc.vpc-gitlab.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.nat-gateway-gitlab.id}"
  }
}

resource "aws_subnet" "subnet-gitlab-private" {
  count                   = "${length(var.cidr_block_private_subnet)}"
  vpc_id                  = "${aws_vpc.vpc-gitlab.id}"
  cidr_block              = "${var.cidr_block_private_subnet[count.index]}"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = false
  tags {
    Name = "subnet-gitlab-private"
  }
}

resource "aws_route_table_association" "rtl-gitlab-private" {
  count          = "${length(var.cidr_block_private_subnet)}"
  route_table_id = "${aws_route_table.rtl-gitlab-private.id}"
  subnet_id      = "${element(aws_subnet.subnet-gitlab-private.*.id, count.index)}"
}