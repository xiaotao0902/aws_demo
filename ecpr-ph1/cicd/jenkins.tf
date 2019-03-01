data "template_file" "jenkins_setup" {
  template = "${file("jenkins_setup.tpl")}"
}

resource "aws_instance" "instance-jenkins" {
  ami                    = "${var.jenkins_ami}"
  instance_type          = "${var.jenkins_instance_type}"
  subnet_id              = "${aws_subnet.subnet-gitlab-public.*.id[0]}"
  key_name               = "${var.jenkins_key_name}"
  vpc_security_group_ids = ["${aws_security_group.security-group-gitlab-public.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.ssm-role-gitlab-profile.name}"
  #associate_public_ip_address = "${var.associate_public_ip_address}"
  tags {
    Name = "instance-jenkins"
  }
  lifecycle {
    ignore_changes = ["private_ip", "root_block_device", "ebs_block_device"]
  }
  
  user_data        ="${data.template_file.jenkins_setup.rendered}"

}