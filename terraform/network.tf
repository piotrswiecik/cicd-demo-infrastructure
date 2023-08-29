resource "aws_vpc" "cicd_demo" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    "Name" = "vpc-eu-central-1-cicd-demo"
  }
}

resource "aws_subnet" "cicd_demo" {
  vpc_id                  = aws_vpc.cicd_demo.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "subnet-eu-central-1-cicd-demo"
  }
}

resource "aws_internet_gateway" "cicd_demo" {
  vpc_id = aws_vpc.cicd_demo.id

  tags = {
    "Name" = "igw-eu-central-1-cicd-demo"
  }
}

resource "aws_route_table" "cicd_demo_public_rt" {
  vpc_id = aws_vpc.cicd_demo.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cicd_demo.id
  }

  tags = {
    "Name" = "rt-eu-central-1-cicd-demo"
  }
}

resource "aws_route_table_association" "cicd_demo_public_rta" {
  subnet_id      = aws_subnet.cicd_demo.id
  route_table_id = aws_route_table.cicd_demo_public_rt.id
}

resource "aws_security_group" "jenkins_controller" {
  vpc_id = aws_vpc.cicd_demo.id

  tags = {
    "Name" = "sg-eu-central-1-jenkins-controller"
  }

  ingress {
    description = "Allow SSH from anywhere for administration"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS from anywhere for Jenkins GUI"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description     = "Allow access to Jenkins agent listener port"
    from_port       = 50000
    to_port         = 50000
    protocol        = "tcp"
    security_groups = [aws_security_group.jenkins_agent.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "jenkins_agent" {
  vpc_id = aws_vpc.cicd_demo.id

  tags = {
    "Name" = "sg-eu-central-1-jenkins-agent"
  }

  ingress {
    description = "Allow SSH from anywhere for administration"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}