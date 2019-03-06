# set up EC2 Instance as a session manager system
resource "aws_instance" "instance-ssm-bastion" {
  ami                    = "${var.bastion_ami}"
  instance_type          = "${var.bastion_instance_type}"
  subnet_id              = "${aws_subnet.public.*.id[0]}"
  key_name               = "${var.bastion_key_name}"
  vpc_security_group_ids = ["${aws_security_group.security-group-ssm-public.id}"]
  iam_instance_profile   = "${aws_iam_instance_profile.ssm-role-eks-profile.name}"
  tags {
    Name = "instance-ssm-bastion"
  }

  lifecycle {
    ignore_changes = ["private_ip", "root_block_device", "ebs_block_device"]
  }
  
  user_data        = <<USERDATA
#!/bin/bash

# enable SSM session manager
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent

sudo yum install -y python-pip
sudo wget pgadmin4-1.0-py2-none-any.whl
sudo pip2 install pgadmin4-1.0-py2-none-any.whl
#rm pgadmin4-1.0-py2-none-any.whl

# enable kubectl
curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/darwin/amd64/aws-iam-authenticator
chmod +x ./aws-iam-authenticator
cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$HOME/bin:$PATH
echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc
sudo yum install -y docker
service docker start 
yum install java-1.8.0-openjdk* -y
wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
yum -y install apache-maven

wget http://services.gradle.org/distributions/gradle-5.2-bin.zip -O /etc/gradle/gradle-5.2-bin.zip


# enable serverspec
sudo yum update -y
sudo amazon-linux-extras install -y ruby2.4
sudo yum install -y redhat-rpm-config
sudo yum install -y ruby-devel
sudo gem install bundler
sudo gen install gc
sudo gem install io-console
sudo gem install rake
sudo gem install serverspec
sudo gen install serverspec-runner
USERDATA
}