data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "tls_private_key" "jenkins_controller" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "jenkins_controller" {
  key_name   = "ec2-eu-central-1-jenkins-controller"
  public_key = tls_private_key.jenkins_controller.public_key_openssh
}

resource "local_file" "jenkins_controller_key" {
  content         = tls_private_key.jenkins_controller.private_key_pem
  filename        = "ec2-eu-central-1-jenkins-controller.pem"
  file_permission = "0600"
}

resource "aws_instance" "jenkins_controller" {
  ami           = data.aws_ami.latest_ubuntu.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.jenkins_controller.key_name
  subnet_id = aws_subnet.cicd_demo.id
  security_groups = [aws_security_group.jenkins_controller.id]

  tags = {
    "Name" = "ec2-eu-central-1-jenkins-controller"
  }
}