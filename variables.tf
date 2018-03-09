variable "associate_public_ip_address" {
  default = true
}

variable "instance_type" {
  type    = "string"
  default = "t2.medium"
}

variable "ebs_optimized" {
  default = false
}

variable "region" {
  type    = "string"
  default = "us-east-1"
}
