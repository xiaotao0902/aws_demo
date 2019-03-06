output "gitlab-serverspec" {
  value =<<CONTENT
  
servers:
  jenkins:
    - jenkins-server
  gitlab:
    - gitlab-server
--- 

jenkins-server:
  host: ${aws_instance.instance-jenkins.public_ip}
  ssh_opts:
    port: 22
    user: "ec2-user"
    keys: "~/.ssh/id_rsa"
    verify_host_key: :never
    
gitlab-server:
  host: localhost
  endpoint: http://${aws_lb.lb-gitlab.dns_name}
  ssh_opts:
    port: 22
    user: "ec2-user"
    keys: "~/.ssh/id_rsa"
    verify_host_key: :never 
 
  CONTENT
}