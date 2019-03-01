data "aws_availability_zones" "available" {}

#Create VPC
resource "aws_vpc" "DEV-EC-Platform-VPC" {
  cidr_block ="192.168.0.0/16"
  tags {
    Name ="DEV-EC-Platform-VPC"  
  }
}

#PUBLIC SUBNETS
resource "aws_subnet" "public" {
	count					= "${length(var.public_subnet)}"
	vpc_id					= "${aws_vpc.DEV-EC-Platform-VPC.id}"
	cidr_block				= "${var.public_subnet[count.index]}"
	availability_zone		= "${data.aws_availability_zones.available.names[count.index]}"
	map_public_ip_on_launch	= true
	tags {
		Name	= "DEV-EC-Platform-Public${count.index}"
	}
}

#PUBLIC ROUTE
resource "aws_internet_gateway" "DEV-EC-Platform-GateWay" {
	vpc_id = "${aws_vpc.DEV-EC-Platform-VPC.id}"
}

#PUBLIC DEFAULT ROUTE
resource "aws_route_table" "EC-Platform-Public-Route" {
	vpc_id	= "${aws_vpc.DEV-EC-Platform-VPC.id}" 
	route {
		cidr_block	= "0.0.0.0/0"
		gateway_id	= "${aws_internet_gateway.DEV-EC-Platform-GateWay.id}"
	}
}

#PUBLIC ROUTE ASSOCIATIONS
resource "aws_route_table_association" "public" {
	count			= "${length(var.public_subnet)}"
	route_table_id	= "${aws_route_table.EC-Platform-Public-Route.id}"
	subnet_id		= "${element(aws_subnet.public.*.id,count.index)}"
}

#PRIVATE SUBNETS
resource "aws_subnet" "private" {
	count					= "${length(var.private_subnet)}"
	vpc_id					= "${aws_vpc.DEV-EC-Platform-VPC.id}"
	cidr_block				= "${var.private_subnet[count.index]}"
	availability_zone		= "${data.aws_availability_zones.available.names[count.index]}"
	map_public_ip_on_launch	= true
	tags {
		Name	= "DEV-EC-Platform-Private${count.index}"
	}
}

#PRIVATE DEFAULT ROUTE
resource "aws_route_table" "EC-Platform-Private-Route" {
	vpc_id = "${aws_vpc.DEV-EC-Platform-VPC.id}"
}

#PRIVATE ROUTE ASSOCIATIONS
resource "aws_route_table_association" "private" {
	count			= "${length(var.private_subnet)}"
	route_table_id	= "${aws_route_table.EC-Platform-Private-Route.id}"
	subnet_id		= "${element(aws_subnet.private.*.id,count.index)}"
}
