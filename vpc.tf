# VPC configuration
resource "aws_vpc" "app_vpc" {
    cidr_block = var.aws_vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = var.environment_vpc_dev
        Environment = var.environment_dev
    }
}

# Internet gateway configuration
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.app_vpc.id
  
    tags = {
        Name = var.environment_igw_dev
        Environment = var.environment_dev
    }
}

# Setup EIP for NAT
resource "aws_eip" "nat_eip" {
    vpc = true
    depends_on = [aws_internet_gateway.igw]
}

# Setup NAT Gateway
resource "aws_nat_gateway" "nat" {
    allocation_id   = aws_eip.nat_eip.id
    subnet_id       = aws_subnet.public_subnet.id 
    depends_on      = [aws_internet_gateway.igw]

    tags = {
        Name        = "nat"
        Environment = var.environment_dev
    }
}

# Setup public subnet
resource "aws_subnet" "public_subnet" {
    vpc_id      = aws_vpc.app_vpc.id
    cidr_block  = var.cidr_public_subnet
    availability_zone = var.availability_zones[0] 

    tags = {
        Name        = "Public subnet"
        Environment = var.environment_dev 
    } 
}

# Setup route table for public subnet
resource "aws_route_table" "vpc_public_subnet_route_table" {
    vpc_id      = aws_vpc.app_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "Public subnet routing table"
        Environment = var.environment_dev
    }
}

# Setup route table association
resource "aws_route_table_association" "vpc_public_subnet_route_association" {
    subnet_id       = aws_subnet.public_subnet.id 
    route_table_id  = aws_route_table.vpc_public_subnet_route_table.id
}

# Setup security group
resource "aws_security_group" "allow_ssh" {
    name        = "allow_ssh_secgroup"
    description = "Allowing ssh inbound trafic"
    vpc_id      = aws_vpc.app_vpc.id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks  = ["0.0.0.0/0"]
    } 

    egress {
        from_port   = 0
        to_port     = 0 
        protocol    = "-1"
        cidr_blocks  = ["0.0.0.0/0"]
    }
}

# Setup private subnet
resource "aws_subnet" "private_subnet" {
    vpc_id              = aws_vpc.app_vpc.id
    cidr_block          = var.cidr_private_subnet
    availability_zone   = var.availability_zones[0] 
    
    tags = {
        Name        = "Private subnet"
        Environment = var.environment_dev
    }
}

# Setup route table for private subnet
resource "aws_route_table" "vpc_private_subnet_route_table" {
    vpc_id = aws_vpc.app_vpc.id

    tags = {
        Name = "Private subnet routing table"
        Environment = var.environment_dev 
    }
}

# Setup route table association for private subnet
resource "aws_route_table_association" "vpc_private_subnet_route_association" {
    subnet_id = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.vpc_private_subnet_route_table.id
}