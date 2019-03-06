# kubernetes configuration for EKS
output "kubectl config" {
  value = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.DEV-EC-Platform-EKS.endpoint}
    certificate-authority-data: ${aws_eks_cluster.DEV-EC-Platform-EKS.certificate_authority.0.data}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${local.cluster_name}"
      env:
        - name: AWS_PROFILE
          value: "${var.aws_profile}"
KUBECONFIG
}

# kubernetes configuration for EKS
output "EKS ConfigMap" {
  value = <<CONFIGMAP
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${aws_iam_role.eks-node-role.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
CONFIGMAP
}
# datebase and elsticashe configuration
output "Eks-info" {
  value =<<CONTENT
datebase
	host:${aws_db_instance.db-postgres-eks.address}
	port:${aws_db_instance.db-postgres-eks.port}
	dbname:${aws_db_instance.db-postgres-eks.name}
	username:${aws_db_instance.db-postgres-eks.username}
cache
	host:${aws_elasticache_cluster.redis-eks.cache_nodes.0.address}
	port:${aws_elasticache_cluster.redis-eks.port}

  CONTENT
}
