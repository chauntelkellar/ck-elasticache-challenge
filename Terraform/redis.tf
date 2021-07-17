resource "aws_elasticache_cluster" "acg-redis" {
  cluster_id           = "acg-redis"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis3.2"
  engine_version       = "3.2.10"
  port                 = 6379
  subnet_group_name    = "redis-subnet"

}

resource "aws_elasticache_subnet_group" "redis-subnet" {
  name       = "redis-subnet"
  subnet_ids = [aws_subnet.private.id]
}

resource "aws_elasticache_parameter_group" "default" {
  name   = "cache-params"
  family = "redis3.2"
}