locals {
	cluster_name	= "DEV-EC-Platform-EKS"
}

#EKS CONFIG
resource "aws_eks_cluster" "DEV-EC-Platform-EKS" {
	name		= "${local.cluster_name}"
	role_arn	= "${aws_iam_role.eks-master-role.arn}"
  
	vpc_config {
		security_group_ids	= ["${aws_security_group.security-group-eks-master.id}"]
		subnet_ids			= ["${aws_subnet.public.*.id}"]
	}

	depends_on = [
		"aws_iam_role_policy_attachment.eks-cluster-policy",
		"aws_iam_role_policy_attachment.eks-service-policy",
	]
}

#EKS LAUNCH CONFIGURATION
resource "aws_launch_configuration" "eks-worker" {
	associate_public_ip_address	= true
	iam_instance_profile		= "${aws_iam_instance_profile.eks-node-role-profile.id}"
	image_id					= "${var.eks_worker_image}"
	instance_type				= "${var.eks_worker_instance_type}"
	name_prefix					= "eks-node-"
	key_name					= "${var.eks_worker_key}"
	enable_monitoring			= false
	security_groups				= ["${aws_security_group.security-group-eks-node.id}"]
	user_data					= <<USERDATA

	#!/bin/bash
	set -o xtrace
	/etc/eks/bootstrap.sh --apiserver-endpoint "${aws_eks_cluster.DEV-EC-Platform-EKS.endpoint}" --b64-cluster-ca "${aws_eks_cluster.DEV-EC-Platform-EKS.certificate_authority.0.data}" "${aws_eks_cluster.DEV-EC-Platform-EKS.name}"

# enable SSM session manager
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent
USERDATA

	root_block_device {
		volume_type	= "gp2"
		volume_size	= 50
	}

	lifecycle {
		create_before_destroy	= true
	}
}

#WORK NODE CONFIGURATION
resource "aws_autoscaling_group" "eks-worker" {
	name					= "eks-worker"
	desired_capacity		= 1
	launch_configuration	= "${aws_launch_configuration.eks-worker.id}"
	max_size				= 10
	min_size				= 1

	vpc_zone_identifier		= ["${aws_subnet.public.*.id}"]

	tag {
		key					= "Name"
		value				= "eks-worker"
		propagate_at_launch	= true
	}

	tag {
		key					= "kubernetes.io/cluster/${local.cluster_name}"
		value				= "owned"
		propagate_at_launch	= true
	}

	lifecycle {
		create_before_destroy	= true
	}
}
