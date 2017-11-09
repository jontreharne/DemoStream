variable "count" {}
variable "keypair" {}
variable "public_subnets" { type = "list" }
variable "availability_zones" {
  type = "list"
}
variable "httpwebserver_sg" {}
variable "ssh_sg" {}
variable "initial_target_group" {}
variable "managerprofile" {}
