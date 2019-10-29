resource "aws_db_subnet_group" "wso2_db_group" {
  count = var.create_rds_instance ? 1 : 0
  name       = "${var.project_name}.${var.domain}-${var.ENVIRONMENT}-wso2-db-group"
  subnet_ids = ["${aws_subnet.swarm_vpc_subnet[0].id}","${aws_subnet.swarm_vpc_subnet[1].id}"]

  tags = {
    Name = "${var.project_name}.${var.domain}-${var.ENVIRONMENT}-wso2-db-group"
	Project = "${var.project_name}"
	Domain = "${var.domain}"
  }
}

resource "aws_db_parameter_group" "db_wso2_param_group" {
  name   = "rds-wso2"
  family = "mysql5.7"

  parameter {
    name  = "max_connections"
    value = "5000"
  }
}

resource "aws_db_instance" "wso2_db_instance" {
  count = var.create_rds_instance ? 1 : 0
  allocated_storage           = 10
  identifier                  = replace("${var.project_name}-${var.ENVIRONMENT}-wso2-db", ".", "-")
  storage_type                = "gp2"
  engine                      = "mysql"
  engine_version              = "5.7"
  instance_class              = "${var.rds_type}"
  username                    = "root"
  password                    = "2GG2vbmxYCnfEsHg"
  parameter_group_name        = "${aws_db_parameter_group.db_wso2_param_group.name}"
  db_subnet_group_name        = "${aws_db_subnet_group.wso2_db_group[0].name}"
  vpc_security_group_ids      = ["${aws_security_group.docker_swarm.id}"]
  backup_retention_period     = 0
  multi_az                    = false
  skip_final_snapshot         = true
  port                        = "3306"
  publicly_accessible         = false

  tags = {
    Name = "${var.project_name}.${var.domain}-${var.ENVIRONMENT}-wso2-db"
	Project = "${var.project_name}"
	Domain = "${var.domain}"
  }
}

