resource "aws_route_table" "public_route_table" {
	vpc_id = "${var.vpc_id}"
	
	tags {
		Name = "Inital VPC Route Public"
	}
}

resource "aws_route" "public_to_igw" {
	route_table_id = "${aws_route_table.public_route_table.id}"
	destination_cidr_block = "0.0.0.0/0"
	gateway_id = "${var.igwid}"
	depends_on = ["aws_route_table.public_route_table"]
}

resource "aws_route_table_association" "public_route" {
	count = "${length(keys(var.public_subnet_map))}"
	subnet_id = "${element(var.public_subnets, count.index)}"
	route_table_id = "${aws_route_table.public_route_table.id}"
	depends_on = ["aws_route_table.public_route_table"]
}	

resource "aws_route_table" "private_route_table" {
	vpc_id = "${var.vpc_id}"
	
	tags {
		Name = "Inital VPC Route Private"
	}
}


resource "aws_route" "private_to_ngw" {
	route_table_id = "${aws_route_table.private_route_table.id}"
	destination_cidr_block = "0.0.0.0/0"
	nat_gateway_id = "${var.ngwid}"
	depends_on = ["aws_route_table.private_route_table"]
}

resource "aws_route_table_association" "private_route" {
	count = "${length(keys(var.private_subnet_map))}"
	subnet_id = "${element(var.private_subnets, count.index)}"
	route_table_id = "${aws_route_table.private_route_table.id}"
	depends_on = ["aws_route_table.private_route_table"]
}	

	