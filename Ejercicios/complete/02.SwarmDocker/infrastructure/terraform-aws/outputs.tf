output "leader-public-ip" {
  value = var.spot_instances ? "${aws_spot_instance_request.master.0.public_ip}" : "${aws_instance.master.0.public_ip}"
}

output "master-public-ip" {
  value = var.spot_instances ? "${aws_spot_instance_request.master.*.public_ip}" : "${aws_instance.master.*.public_ip}"
}

output "worker-public-ip" {
  value = var.spot_instances ? "${aws_spot_instance_request.master.*.public_ip}" : "${aws_instance.worker.*.public_ip}"
}


output "leader-private-ip" {
  value = var.spot_instances ? "${aws_spot_instance_request.master.0.private_ip}" : "${aws_instance.master.0.private_ip}"
}

output "master-private-ip" {
  value = var.spot_instances ? "${aws_spot_instance_request.master.*.private_ip}" : "${aws_instance.master.*.private_ip}"
}

output "worker-private-ip" {
  value = var.spot_instances ? "${aws_spot_instance_request.worker.*.private_ip}" : "${aws_instance.worker.*.private_ip}"
}
