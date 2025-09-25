# RDS PostgreSQL for orders service
resource "aws_db_subnet_group" "orders" {
  name       = "orders-db-subnet-group"
  subnet_ids = module.vpc.private_subnets

  tags = merge(var.common_tags, {
    Name = "Orders DB subnet group"
  })
}

resource "aws_db_instance" "orders_postgres" {
  identifier = "orders-postgres"
  
  engine         = "postgres"
  engine_version = "14.9"
  instance_class = "db.t3.micro"
  
  allocated_storage = 20
  storage_encrypted = true
  
  db_name  = "orders"
  username = "orders_user"
  password = random_password.orders_db_password.result
  
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.orders.name
  
  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "Sun:04:00-Sun:05:00"
  
  skip_final_snapshot = true
  deletion_protection = false
  
  tags = merge(var.common_tags, {
    Name = "Orders PostgreSQL Database"
  })
}

# RDS MySQL for catalog service
resource "aws_db_instance" "catalog_mysql" {
  identifier = "catalog-mysql"
  
  engine         = "mysql"
  engine_version = "8.0.35"
  instance_class = "db.t3.micro"
  
  allocated_storage = 20
  storage_encrypted = true
  
  db_name  = "catalog"
  username = "catalog_user"
  password = random_password.catalog_db_password.result
  
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.orders.name
  
  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "Sun:04:00-Sun:05:00"
  
  skip_final_snapshot = true
  deletion_protection = false
  
  tags = merge(var.common_tags, {
    Name = "Catalog MySQL Database"
  })
}

# DynamoDB for carts service
resource "aws_dynamodb_table" "carts" {
  name           = "carts"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = merge(var.common_tags, {
    Name = "Carts DynamoDB Table"
  })
}

# Random passwords
resource "random_password" "orders_db_password" {
  length  = 16
  special = true
}

resource "random_password" "catalog_db_password" {
  length  = 16
  special = true
}

# Security group for RDS
resource "aws_security_group" "rds" {
  name_prefix = "rds-sg-"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "RDS Security Group"
  })
}
