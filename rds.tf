// CloudBuild RDS Instance
resource "aws_db_instance" "cloudbuild-rds" {
    allocated_storage = 10

    db_name = var.database.database

    engine = "mysql"
    engine_version = "5.7"

    instance_class = "db.t3.micro"

    username = var.database.username
    password = var.database.password

    parameter_group_name = "default.mysql5.7"

    db_subnet_group_name = aws_db_subnet_group.cloudbuild-rds-subnet-group.name

    vpc_security_group_ids = [ aws_security_group.cloudbuild-rds-nsg.id ]

    skip_final_snapshot = true
    multi_az = false
}

// Test RDS Subnet Group
resource "aws_db_subnet_group" "cloudbuild-rds-subnet-group" {
    name = "cloudbuild-rds-subnet-group"
    
    subnet_ids = [ aws_subnet.cloudbuild-vpc-subnet-2.id, aws_subnet.cloudbuild-vpc-subnet-3.id ]

    tags = {
        Name = "cloudbuild-rds-subnet-group"
    }
}