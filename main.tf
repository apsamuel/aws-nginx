#configure provider - make sure to set your AWS_DEFAULT_REGION, AWS_ACCESS_KEY_ID & AWS_SECRET_ACCESS_KEY accordingly.
provider "aws" {
  region = "us-east-1"
}

#grab networking information
data "aws_vpc" "default" {
  id = "${var.vpc}"
}

data "aws_subnet" "net" {
  vpc_id = "${data.aws_vpc.default.id}"

  filter {
    name   = "availability-zone"
    values = ["us-east-1a"]
  }
}

#locate AMI - make sure you have an AMI named nginx-simple-web in your inventory
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

#generate TLS/AWS::KeyPair
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

#configure instance profile
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

#configure security
resource "aws_security_group" "instance" {
  name        = "${aws_iam_instance_profile.profile.name}-sg"
  description = "Nginx Server Security Group"
  vpc_id      = "${data.aws_vpc.default.id}"

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

#configure instance
resource "aws_instance" "instance" {
  subnet_id                   = "${data.aws_subnet.net.id}"
  security_groups             = ["${aws_security_group.instance.id}"]
  ami                         = "${data.aws_ami.nginx.id}"
  key_name                    = "${aws_key_pair.nginx.key_name}"
  iam_instance_profile        = "${aws_iam_instance_profile.profile.name}"
  instance_type               = "${var.instance_type}"
  associate_public_ip_address = "${var.associate_public_ip_address ? true : false}"
  ebs_optimized               = "${var.ebs_optimized ? true : false}"

  tags {
    Name    = "nginx-companion-website"
    Env     = "production"
    Contact = "aaron.psamuel@gmail.com"
  }
}

#- configure dns  
data "aws_route53_zone" "dns" {
  name = "${var.domain}"
}

resource "aws_route53_record" "cname" {
  count   = "${var.enable_dns ? 1 : 0 }"
  zone_id = "${data.aws_route53_zone.dns.zone_id}"
  name    = "toolbox.${data.aws_route53_zone.dns.name}"
  type    = "A"
  ttl     = "5"
  records = ["${aws_instance.instance.public_ip}"]
}
