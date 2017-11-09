resource "aws_subnet" "public_subnet" {
	count = "${length(keys(var.public_subnet_map))}"
	vpc_id = "${var.vpc_id}"
	cidr_block = "${element(var.public_subnet_map[count.index],1)}"
	availability_zone ="${element(var.public_subnet_map[count.index],0)}"
	
	tags {
		Name = "Initial VPC Public Subnet"
	}
}

resource "aws_subnet" "private_subnet" {
	count = "${length(keys(var.private_subnet_map))}"
	vpc_id = "${var.vpc_id}"
	cidr_block = "${element(var.private_subnet_map[count.index],1)}"
	availability_zone ="${element(var.private_subnet_map[count.index],0)}"
	
	tags {
		Name = "Initial VPC Private Subnet"
	}
}