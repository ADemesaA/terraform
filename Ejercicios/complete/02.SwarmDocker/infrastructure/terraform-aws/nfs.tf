resource "aws_efs_file_system" "storage_nfs" {
  creation_token = "${var.project_name}.${var.domain}-${var.ENVIRONMENT}-storage-nfs"

  tags = {
    Name = "${var.project_name}.${var.domain}-${var.ENVIRONMENT}-storage-nfs"
	Project = "${var.project_name}"
	Domain = "${var.domain}"
  }
}

resource "aws_efs_mount_target" "storage_nfs" {

  file_system_id  = aws_efs_file_system.storage_nfs.id
  subnet_id       = "${aws_subnet.swarm_vpc_subnet[0].id}"
  security_groups = [
	"${aws_security_group.docker_swarm.id}"
  ]
}
