// CloudBuild Virtual Private Cloud (VPC)
resource "aws_vpc" "cloudbuild-vpc" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"

    enable_dns_hostnames = true

    tags = {
        Name = "cloudbuild-vpc"
    }
}

// CloudBuild VPC Subnet 1
resource "aws_subnet" "cloudbuild-vpc-subnet-1" {
    vpc_id = aws_vpc.cloudbuild-vpc.id
    cidr_block = "10.0.1.0/24"

    map_public_ip_on_launch = true
    availability_zone = "ap-southeast-2a"

    tags = {
        Name = "cloudbuild-vpc-subnet-1"
    }
}

// CloudBuild VPC Subnet 2
resource "aws_subnet" "cloudbuild-vpc-subnet-2" {
    vpc_id = aws_vpc.cloudbuild-vpc.id
    cidr_block = "10.0.2.0/24"

    map_public_ip_on_launch = true
    availability_zone = "ap-southeast-2a"

    tags = {
        Name = "cloudbuild-vpc-subnet-2"
    }
}

// CloudBuild VPC Subnet 3 (Required for Multi-AZ, not used)
resource "aws_subnet" "cloudbuild-vpc-subnet-3" {
    vpc_id = aws_vpc.cloudbuild-vpc.id
    cidr_block = "10.0.3.0/24"

    map_public_ip_on_launch = true
    availability_zone = "ap-southeast-2b"

    tags = {
        Name = "cloudbuild-vpc-subnet-3"
    }
}

// CloudBuild VPC Route Table
resource "aws_route_table" "cloudbuild-vpc-route-table" {
  vpc_id = aws_vpc.cloudbuild-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cloudbuild-vpc-internet-gateway.id
  }

  tags = {
    Name = "cloudbuild-vpc-route-table"
  }
}

// CloudBuild VPC Route Table Association 1
resource "aws_route_table_association" "cloudbuild-vpc-route-table-assoc-1" {
    subnet_id = aws_subnet.cloudbuild-vpc-subnet-1.id
    route_table_id = aws_route_table.cloudbuild-vpc-route-table.id
}

// CloudBuild Internet Gateway
resource "aws_internet_gateway" "cloudbuild-vpc-internet-gateway" {
    vpc_id = aws_vpc.cloudbuild-vpc.id

    tags = {
      Name = "cloudbuild-vpc-internet-gateway"
    }
}

// CloudBuild EC2 Security Group
resource "aws_security_group" "cloudbuild-ec2-nsg" {
    name = "cloudbuild-ec2-nsg"

    vpc_id = aws_vpc.cloudbuild-vpc.id

    tags = {
        Name = "cloudbuild-ec2-nsg"
    }
}

// CloudBuild EC2 Security Group Rules

// SSH
resource "aws_vpc_security_group_ingress_rule" "cloudbuild-ec2-nsg-rule-ssh" {
    security_group_id = aws_security_group.cloudbuild-ec2-nsg.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 22
    to_port = 22
    ip_protocol = "tcp"
}

// HTTP
resource "aws_vpc_security_group_ingress_rule" "cloudbuild-nsg-rule-http" {
    security_group_id = aws_security_group.cloudbuild-ec2-nsg.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 80
    to_port = 80
    ip_protocol = "tcp"
}

// Outbound
resource "aws_vpc_security_group_egress_rule" "cloudbuild-nsg-rule-outbound" {
    security_group_id = aws_security_group.cloudbuild-ec2-nsg.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 0
    to_port = 0
    ip_protocol = "-1"
}

// CloudBuild RDS Security Group
resource "aws_security_group" "cloudbuild-rds-nsg" {
    name = "cloudbuild-rds-nsg"

    vpc_id = aws_vpc.cloudbuild-vpc.id

    tags = {
        Name = "cloudbuild-rds-nsg"
    }
}

// CloudBuild RDS Security Group Rules

// Allow Subnet 1 (EC2) In/Out
resource "aws_vpc_security_group_ingress_rule" "cloudbuild-rds-rule-inbound" {
    security_group_id = aws_security_group.cloudbuild-rds-nsg.id
    cidr_ipv4 = aws_subnet.cloudbuild-vpc-subnet-1.cidr_block
    from_port = 0
    to_port = 3306
    ip_protocol = "-1"
}

resource "aws_vpc_security_group_egress_rule" "cloudbuild-rds-rule-outbound" {
    security_group_id = aws_security_group.cloudbuild-rds-nsg.id
    cidr_ipv4 = aws_subnet.cloudbuild-vpc-subnet-1.cidr_block
    from_port = 3306
    to_port = 0
    ip_protocol = "-1"
}