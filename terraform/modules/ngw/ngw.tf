resource "aws_nat_gateway" "ngw" {
	allocation_id = "${var.ngweipid}"
	subnet_id = "${element(var.public_subnets, 1)}"
}