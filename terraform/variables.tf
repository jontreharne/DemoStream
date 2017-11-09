variable aws_access_key {}
variable aws_secret_key {}

variable "aws_default_region" {
	default = "eu-west-2"
}

variable "vpc_range" {
	default = "10.0.0.0/16"
}

variable "availability_zones" {
  default = ["eu-west-2a", "eu-west-2b"]
}

variable "public_subnet_map" {
	type = "map"
	default = {
		"0" = ["eu-west-2a","10.0.1.0/26"]
		"1" = ["eu-west-2b","10.0.1.64/26"]
	}
}

variable "private_subnet_map" {
	type = "map"
	default = {
		"0" = ["eu-west-2a","10.0.2.0/24"]
		"1" = ["eu-west-2b","10.0.3.0/24"]
	}
}
