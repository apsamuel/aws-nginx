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

variable "vpc" {
  type    = "string"
  default = "vpc-a42399c1"
}

variable "region" {
  type    = "string"
  default = "us-east-1"
}
