resource "aws_instance" "instance-gitlab-bastion" {
  ami                    = "${var.bastion_ami}"
  instance_type          = "${var.bastion_instance_type}"
  subnet_id              = "${aws_subnet.subnet-gitlab-public.*.id[0]}"
  key_name               = "${var.bastion_key_name}"
  vpc_security_group_ids = ["${aws_security_group.security-group-gitlab-public.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.ssm-role-gitlab-profile.name}"
  tags {
    Name = "instance-gitlab-bastion"
  }

  lifecycle {
    ignore_changes = ["private_ip", "root_block_device", "ebs_block_device"]
  }
  
  user_data        = <<USERDATA
#!/bin/bash
set -o xtrace
# enable SSM session manager
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent

sudo yum install -y gcc
sudo yum install -y python-pip
sudo wget https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v4.2/pip/pgadmin4-4.2-py2.py3-none-any.whl
sudo pip2 install pgadmin4-4.2-py2.py3-none-any.whl
#rm pgadmin4-4.2-py2.py3-none-any.whl
USERDATA
}