resource "aws_security_group" "docker_swarm" {
  name = "docker-swarm"
  vpc_id = "${aws_vpc.swarm_vpc.id}"

  # Allow connect itself
  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "${var.project_name}-${var.ENVIRONMENT}-docker-swarm"
	Project = "${var.project_name}"
	Domain = "${var.domain}"
  }
}

resource "aws_security_group" "ssh" {
  name = "ssh"
  vpc_id = "${aws_vpc.swarm_vpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "${var.project_name}-${var.ENVIRONMENT}-ssh"
    Terraform = "true"
	Project = "${var.project_name}"
	Domain = "${var.domain}"
  }
}

resource "aws_security_group" "http" {
  name = "http"
  vpc_id = "${aws_vpc.swarm_vpc.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "${var.project_name}-${var.ENVIRONMENT}-http"
    Terraform = "true"
	Project = "${var.project_name}"
	Domain = "${var.domain}"
  }
}
