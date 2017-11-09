variable "public_subnets" { type = "list" }
variable "vpc_id" {}
variable "private_subnets" { type = "list" }
variable "availability_zones" {
  type = "list"
}
variable "count" {}
variable "keypair" {}
variable "httpswebserver_sg" {}
variable "httpwebserver_sg" {}
variable "ssh_sg" {}
variable "managerprofile" {}
variable "run" {}
