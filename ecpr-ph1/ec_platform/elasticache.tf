resource "aws_elasticache_subnet_group" "cache-subnet-group-eks" {
  name       = "cache-subnet-group-eks"
  subnet_ids = ["${aws_subnet.public.*.id}"]
}

resource "aws_elasticache_cluster" "redis-eks" {
  cluster_id           = "cluster-redis-eks"
  engine               = "${var.cluster_engine}"
  node_type            = "${var.cluster_node_type}"
  num_cache_nodes      = "${var.cluster_num_cache_nodes}"
  parameter_group_name = "${var.cluster_parameter_group_name}"
  engine_version       = "${var.cluster_engine_version}"
  port                 = "${var.cluster_port}"
  subnet_group_name    = "${aws_elasticache_subnet_group.cache-subnet-group-eks.id}"
  security_group_ids   = ["${aws_security_group.security-group-ec-cache.id}"]
  apply_immediately    = true
}

