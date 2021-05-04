# creates a vpc, subnet, igw, route table and sg

resource "aws_vpc" "test-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "test-vpc"
  }
}
resource "aws_subnet" "test-subnet-az1" {
  vpc_id = "${aws_vpc.test-vpc.id}"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "subnet-1a"
  }
}

resource "aws_internet_gateway" "test-igw" {
  vpc_id = "${aws_vpc.test-vpc.id}"
  
  tags = {
    Name = "test-igw"
  }
}

resource "aws_route_table" "test-public-route-table" {
  vpc_id = "${aws_vpc.test-vpc.id}"
    
    route {
        cidr_block = "0.0.0.0/0" 
        gateway_id = "${aws_internet_gateway.test-igw.id}" 
    }
    
    tags {
        Name = "test-public-route-table"
    }
}

resource "aws_route_table_association" "test-public-subnet-1"{
    subnet_id = "${aws_subnet.test-subnet-az1.id}"
    route_table_id = "${aws_route_table.test-public-route-table.id}"
}

resource "aws_security_group" "ssh-allowed" {
    vpc_id = "${aws_vpc.test-vpc.id}"
    
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags {
        Name = "ssh-allowed"
    }
}
