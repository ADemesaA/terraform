data "template_file" "workers" {
    template = "${file("./templates/ansible-inventory-workers.tpl")}"
	count    = "${var.worker_count}"
	vars = {
		swarm_worker_name = var.spot_instances ? "${aws_spot_instance_request.worker[count.index].private_ip} ansible_user=${var.so_user}" : "${aws_instance.worker[count.index].private_ip} ansible_user=${var.so_user}"
	}
}

data "template_file" "masters" {
    template = "${file("./templates/ansible-inventory-masters.tpl")}"
	count    = "${var.master_count - 1}"
	vars = {
		swarm_master_name = var.spot_instances ? "${aws_spot_instance_request.master[count.index+1].private_ip} ansible_user=${var.so_user}" : "${aws_instance.master[count.index+1].private_ip} ansible_user=${var.so_user}"
	}
}


data  "template_file" "ansible_inventory" {
    template = "${file("./templates/ansible-inventory.tpl")}"
    vars = {
        swarm_leader_name = var.spot_instances ? "${aws_spot_instance_request.master[0].private_ip} ansible_user=${var.so_user}" : "${aws_instance.master[0].private_ip} ansible_user=${var.so_user}"
        swarm_masters = "${join("\n", data.template_file.masters.*.rendered)}"
        swarm_workers = "${join("\n", data.template_file.workers.*.rendered)}"
    }
}

resource "local_file" "inventory_file" {
  content  = "${data.template_file.ansible_inventory.rendered}"
  filename = "../../platform/ansible/swarm-inventory.ini"
}

data  "template_file" "ansible_ssh_cfg" {
    template = "${file("./templates/ansible-ssh-cfg.tpl")}"
    vars = {
        swarm_master_public_ip = var.spot_instances ? "${aws_spot_instance_request.master[0].public_ip}" : "${aws_instance.master[0].public_ip}"            
    }
}

resource "local_file" "ssh_cfg_file" {
  content  = "${data.template_file.ansible_ssh_cfg.rendered}"
  filename = "../../platform/ansible/ssh.cfg"
}

data  "template_file" "ansible_vars" {
    template = "${file("./templates/infra-vars.tpl")}"
    vars = {
        mysql_host = var.create_rds_instance ? "${aws_db_instance.wso2_db_instance[0].address}" : "mysql"
        mysql_port = var.create_rds_instance ? "${aws_db_instance.wso2_db_instance[0].port}" : "3306"
        nfs_path = "${aws_efs_file_system.storage_nfs.dns_name}:/"
        mysql_docker = var.create_rds_instance ? "false" : "true"
        so_user = var.so_user
    }
}

resource "local_file" "ansible_vars" {
  content  = "${data.template_file.ansible_vars.rendered}"
  filename = "../../platform/ansible/infra_vars.yaml"
}

data "template_file" "workers_tags" {
    template = "${file("./templates/workers-tags.tpl")}"
    count = var.spot_instances ? "${var.worker_count}" : 0
	vars = {
		swarm_worker_spot_req_id = "${aws_spot_instance_request.worker[count.index].id}"
		swarm_worker_spot_inst_id = "${aws_spot_instance_request.worker[count.index].spot_instance_id}"
	}
}

data "template_file" "masters_tags" {
    template = "${file("./templates/masters-tags.tpl")}"
  count = var.spot_instances ? "${var.master_count}" : 0
	vars = {
		swarm_master_spot_req_id = "${aws_spot_instance_request.master[count.index].id}"
		swarm_master_spot_inst_id = "${aws_spot_instance_request.master[count.index].spot_instance_id}"
	}
}


data  "template_file" "ec2_tags" {
    template = "${file("./templates/set-tags.sh.tpl")}"
    vars = {
        swarm_masters_tags = "${join("\n", data.template_file.masters_tags.*.rendered)}"
        swarm_workers_tags = "${join("\n", data.template_file.workers_tags.*.rendered)}"
    }
}

resource "local_file" "ec2_tags_file" {
  content  = "${data.template_file.ec2_tags.rendered}"
  filename = "../../platform/ansible/set-tags.sh"
}


