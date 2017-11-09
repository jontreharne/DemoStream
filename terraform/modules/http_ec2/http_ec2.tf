resource "aws_instance" "httpwebserver" {
  count = "${var.count}"
  ami           = "ami-1a7f6d7e"
  instance_type = "t2.micro"
  key_name  = "${var.keypair}"
  availability_zone = "${element(var.availability_zones, count.index)}"
  subnet_id = "${element(var.public_subnets, count.index)}"
  associate_public_ip_address = true
  user_data = "${file("${path.cwd}/http_webserver.sh")}"
  iam_instance_profile = "${var.managerprofile}"

  connection {
          user = "ec2-user"
          private_key = "${file("~/.ssh/AWS-WebServers-KeyPair.pem")}"
      }

  vpc_security_group_ids = ["${var.httpwebserver_sg}","${var.ssh_sg}"]

  tags {
    Name = "HTTPWebServer.${count.index}"
  }
}

resource "aws_lb_target_group_attachment" "httpinstance" {
 count = "${var.count}"
 target_group_arn = "${var.initial_target_group}"
 target_id        = "${element(aws_instance.httpwebserver.*.id, count.index)}"
 port             = 80
}
