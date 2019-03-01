#!/bin/bash
set -e -x

function waitForJenkins() {
    echo "Waiting jenkins to launch on 8080..."

    while ! nc -z localhost 8080; do
      sleep 0.1 # wait for 1/10 of the second before check again
    done

    echo "Jenkins launched"
}

function waitForPasswordFile() {
    echo "Waiting jenkins to generate password..."

    while [ ! -f /var/lib/jenkins/secrets/initialAdminPassword ]; do
      sleep 2 
    done

    echo "Password created"
}

set -o xtrace
# enable SSM session manager
#sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
#sudo systemctl enable amazon-ssm-agent
#sudo systemctl start amazon-ssm-agent

sudo yum install -y nc
sudo yum install -y java-1.8.0-openjdk.x86_64
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum install -y jenkins

sudo service jenkins start
sudo chkconfig --add jenkins

waitForJenkins

curl  -L http://updates.jenkins-ci.org/update-center.json | sed '1d;$d' | curl -X POST -H 'Accept: application/json' -d @- http://localhost:8080/updateCenter/byId/default/postBack

sleep 10

waitForJenkins

sudo cp /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar /var/lib/jenkins/jenkins-cli.jar

waitForPasswordFile

PASS=$(sudo bash -c "cat /var/lib/jenkins/secrets/initialAdminPassword")

sleep 10

# SET AGENT PORT
#xmlstarlet ed -u "//slaveAgentPort" -v "jnlp_port" /var/lib/jenkins/config.xml > /tmp/jenkins_config.xml
#sudo mv /tmp/jenkins_config.xml /var/lib/jenkins/config.xml
#sudo service jenkins restart

#waitForJenkins

#sleep 10

# INSTALL PLUGINS
#sudo java -jar /var/lib/jenkins/jenkins-cli.jar -s http://localhost:8080 -auth admin:$PASS install-plugin plugins

# RESTART JENKINS TO ACTIVATE PLUGINS
sudo java -jar /var/lib/jenkins/jenkins-cli.jar -s http://localhost:8080 -auth admin:$PASS restart