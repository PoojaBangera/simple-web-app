# variables.tf
variable "access_key" {
  default = "AKIAXWWTK6HEFJ6FMLCJ"
}
variable "secret_key" {
  default = "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"
}
variable "region" {
  default = "us-east-1"
}
variable "availabilityZone1" {
  description = "EC2 region for the VPC"
  default = "us-east-1a"
}
variable "availabilityZone2" {
  description = "EC2 region for the VPC"
  default = "us-east-1b"
}
variable "instanceTenancy" {
  default = "default"
}
variable "dnsSupport" {
  default = true
}
variable "dnsHostNames" {
  default = true
}
variable "vpcCIDRblock" {
  default = "10.0.0.0/16"
}
variable "subnet2CIDRblock" {
  default = "10.0.3.0/24"
}
variable "subnet1CIDRblock" {
  default = "10.0.2.0/24"
}

variable "destinationCIDRblock" {
  default = "0.0.0.0/0"
}
variable "ingressCIDRblock" {
  type = list
  default = [
    "0.0.0.0/0"]
}
variable "egressCIDRblock" {
  type = list
  default = [
    "0.0.0.0/0"]
}
variable "mapPublicIP" {
  default = true
}

variable "internet_cidr_block" {
  description = "Internet cidr block"
  default = "0.0.0.0/0"
}
variable "key_name" {}
# end of variables.tf