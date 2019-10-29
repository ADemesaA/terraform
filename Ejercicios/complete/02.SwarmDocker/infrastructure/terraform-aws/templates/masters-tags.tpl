aws ec2 describe-spot-instance-requests --spot-instance-request-ids ${swarm_master_spot_req_id} --query "SpotInstanceRequests[0].Tags" > tags.json
aws ec2 create-tags --resources ${swarm_master_spot_inst_id} --tags file://tags.json && rm -rf tags.json
