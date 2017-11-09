variable "vpc_id" {}
variable "public_subnet_map" { type = "map" }
variable "private_subnet_map" { type = "map" }
variable "public_subnets" { type = "list" }
variable "private_subnets" { type = "list" }
variable "ngwid" {}
variable "igwid" {}