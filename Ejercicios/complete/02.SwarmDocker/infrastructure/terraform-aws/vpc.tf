resource "aws_vpc" "swarm_vpc" {
  cidr_block = "10.0.0.0/26"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "${var.project_name}-${var.ENVIRONMENT}-swarm-vpc"
	Project = "${var.project_name}"
	Domain = "${var.domain}"
  }
}

resource "aws_subnet" "swarm_vpc_subnet" {
  count = 2
  cidr_block = "${cidrsubnet(aws_vpc.swarm_vpc.cidr_block, 1, count.index)}"
  vpc_id = "${aws_vpc.swarm_vpc.id}"
  availability_zone = "${var.aws_az[count.index]}"

  tags = {
    Name = "${var.project_name}-${var.ENVIRONMENT}-swarm-vpc-subnet${count.index+1}"
	Project = "${var.project_name}"
	Domain = "${var.domain}"
  }

}

resource "aws_internet_gateway" "swarm_gw" {
    vpc_id = "${aws_vpc.swarm_vpc.id}"

    tags = {
        Name = "${var.project_name}-${var.ENVIRONMENT}-swarm-gw"
		Project = "${var.project_name}"
		Domain = "${var.domain}"
    }
}

resource "aws_route_table" "swarm_route_table" {
    vpc_id = "${aws_vpc.swarm_vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.swarm_gw.id}"
    }
    tags = {
        Name = "${var.project_name}-${var.ENVIRONMENT}-swarm-route-table"
		Project = "${var.project_name}"
		Domain = "${var.domain}"
    }
}

resource "aws_route_table_association" "swarm_subnet_association" {
  count= 2
  subnet_id      = "${aws_subnet.swarm_vpc_subnet[count.index].id}"
  route_table_id = "${aws_route_table.swarm_route_table.id}"
}
