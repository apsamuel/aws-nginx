output "id" {
  value = "${ aws_instance.instance.id}"
}

output "public_ip" {
  value = "${aws_instance.instance.public_ip}"
}

output "private_ip" {
  value = "${ aws_instance.instance.private_ip}"
}

output "public_url" {
  value = "http://${aws_instance.instance.public_dns}"
}

output "access_key_name" {
  value = "${aws_key_pair.nginx.key_name}"
}

output "access_key_file" {
  value = "${local_file.public_key_ssh.filename }"
}

output "subnet_group" {
  value = "${aws_instance.instance.subnet_id}"
}

output "security_group" {
  value = "${aws_security_group.instance.name}"
}

output "security_rules" {
  value = "${aws_security_group.instance.ingress}"
}
