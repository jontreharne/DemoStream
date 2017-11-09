variable "count" {}
variable "keypair" {}
variable "private_subnets" { type = "list" }
variable "availability_zones" {
  type = "list"
}
variable "httpwebserver_sg" {}
variable "ssh_sg" {}
