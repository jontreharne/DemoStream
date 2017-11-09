resource "aws_vpc" "vpc" {
	cidr_block = "${var.vpc_range}"
	enable_dns_hostnames = true
	
	tags {
		Name = "Initial VPC"
		}
}