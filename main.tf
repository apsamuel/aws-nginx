provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "nginx" {
  most_recent = true

  filter = {
    name   = "name"
    values = ["nginx-simple-web*"]
  }

  filter = {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter = {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter = {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "tls_private_key" "nginx" {
  algorithm = "RSA"
}

resource "random_id" "uniqkey" {
  byte_length = 8
}

resource "local_file" "private_key" {
  content  = "${tls_private_key.nginx.private_key_pem}"
  filename = "${path.module}/output/nginx-${random_id.uniqkey.hex}.pem"
}

resource "local_file" "public_key" {
  content  = "${tls_private_key.nginx.public_key_pem}"
  filename = "${path.module}/output/nginx-${random_id.uniqkey.hex}.pem.pub"
}

resource "local_file" "public_key_ssh" {
  content  = "${tls_private_key.nginx.public_key_openssh}"
  filename = "${path.module}/output/nginx-${random_id.uniqkey.hex}.pub"
}

resource "aws_key_pair" "nginx" {
  key_name   = "nginx-${random_id.uniqkey.hex}"
  public_key = "${tls_private_key.nginx.public_key_openssh}"
}

resource "aws_iam_instance_profile" "profile" {
  name = "nginx-companion-website"
  role = "${aws_iam_role.role.name}"
}

resource "aws_iam_role" "role" {
  name = "nginx-companion-website"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_security_group" "instance" {
  name        = "${aws_iam_instance_profile.profile.name}-sg"
  description = "Nginx Server Security Group"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "instance" {
  ami                         = "${data.aws_ami.nginx.id}"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  security_groups             = ["${aws_security_group.instance.id}"]
  key_name                    = "${aws_key_pair.nginx.name}"
  iam_instance_profile        = "${aws_iam_instance_profile.profile.name}"

  tags {
    Name    = "nginx-companion-website"
    Env     = "production"
    Contact = "aaron.psamuel@gmail.com"
  }
}
