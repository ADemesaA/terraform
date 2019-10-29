resource "aws_key_pair" "default"{
  key_name = "${var.project_name}.${var.domain}-${var.ENVIRONMENT}-kp"
  public_key = "${file("${var.key_path}")}"
}

resource "aws_instance" "master" {
  count = var.spot_instances ? 0 : "${var.master_count}"
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "${aws_key_pair.default.id}"
  
  subnet_id = "${aws_subnet.swarm_vpc_subnet[0].id}"
  vpc_security_group_ids = [
	"${aws_security_group.docker_swarm.id}",
	"${aws_security_group.ssh.id}",
	"${aws_security_group.http.id}",
  ]
  associate_public_ip_address = "true"

  tags = {
	Name  = "${var.project_name}.${var.domain}-${var.ENVIRONMENT}-swarm-master${count.index + 1}"
	Project = "${var.project_name}"
	Domain = "${var.domain}"
  }
  
  root_block_device {
    volume_type = "gp2"
    volume_size = "20"
  }
}

resource "aws_instance" "worker" {
  count = var.spot_instances ? 0 : "${var.worker_count}"
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "${aws_key_pair.default.id}"

  subnet_id = "${aws_subnet.swarm_vpc_subnet[0].id}"
  vpc_security_group_ids = [
	"${aws_security_group.docker_swarm.id}",
	"${aws_security_group.ssh.id}",
  ]
  associate_public_ip_address = "true"

  tags = {
	Name  = "${var.project_name}.${var.domain}-${var.ENVIRONMENT}-swarm-worker${count.index + 1}"
	Project = "${var.project_name}"
	Domain = "${var.domain}"
  }
  root_block_device {
    volume_type = "gp2"
    volume_size = "20"
  }
}

resource "aws_spot_instance_request" "master" {
  count = var.spot_instances ? "${var.master_count}" : 0
  ami = "${var.ami}"
  spot_price    = "${var.spot_price}"
  instance_type = "${var.instance_type}"
  wait_for_fulfillment = true
  spot_type = "one-time"
  key_name = "${aws_key_pair.default.id}"
	
  subnet_id = "${aws_subnet.swarm_vpc_subnet[0].id}"
  vpc_security_group_ids = [
	"${aws_security_group.docker_swarm.id}",
	"${aws_security_group.ssh.id}",
	"${aws_security_group.http.id}",
  ]
  associate_public_ip_address = "true"

  tags = {
	Name  = "${var.project_name}.${var.domain}-${var.ENVIRONMENT}-swarm-master${count.index + 1}"
	Project = "${var.project_name}"
	Domain = "${var.domain}"
  }
  root_block_device {
    volume_type = "gp2"
    volume_size = "20"
  }
}

resource "aws_spot_instance_request" "worker" {
  count = var.spot_instances ? "${var.worker_count}" : 0
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  spot_price    = "${var.spot_price}"
  wait_for_fulfillment = true
  spot_type = "one-time"
  key_name = "${aws_key_pair.default.id}"

  subnet_id = "${aws_subnet.swarm_vpc_subnet[0].id}"
  vpc_security_group_ids = [
	"${aws_security_group.docker_swarm.id}",
	"${aws_security_group.ssh.id}",
  ]
  associate_public_ip_address = "true"

  tags = {
	Name  = "${var.project_name}.${var.domain}-${var.ENVIRONMENT}-swarm-worker${count.index + 1}"
	Project = "${var.project_name}"
	Domain = "${var.domain}"
  }
  root_block_device {
    volume_type = "gp2"
    volume_size = "20"
  }
}
