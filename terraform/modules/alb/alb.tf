resource "aws_instance" "albwebserver" {
  count = "${var.count}"
  ami           = "ami-1a7f6d7e"
  instance_type = "t2.micro"
  key_name  = "${var.keypair}"
  availability_zone = "${element(var.availability_zones, count.index)}"
  subnet_id = "${element(var.public_subnets, count.index)}"
  associate_public_ip_address = true
  iam_instance_profile = "${var.managerprofile}"

  connection {
          user = "ec2-user"
          private_key = "${file("~/.ssh/AWS-WebServers-KeyPair.pem")}"
      }

  security_groups = ["${var.httpswebserver_sg}","${var.ssh_sg}","${var.httpwebserver_sg}"]

  tags {
    Name = "ALBWebServer.${count.index}"
  }

  provisioner "file" {
    source      = "bootstraps/http_webserver.sh"
    destination = "/tmp/http_webserver.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/http_webserver.sh",
      "sudo /tmp/http_webserver.sh",
    ]
  }
}

resource "aws_alb" "publicalb" {
	name = "publicalb"
	load_balancer_type = "application"
	internal = false
	security_groups = ["${var.httpswebserver_sg}","${var.ssh_sg}","${var.httpwebserver_sg}"]
	subnets = ["${var.public_subnets}"]

	enable_deletion_protection = false

	tags {
		Name = "Inital VPC Public ALB"
	}
}

resource "aws_alb_target_group" "initial_target_group" {
	name = "initial-group"
	port = "80"
	protocol = "HTTP"
	vpc_id = "${var.vpc_id}"

	health_check {
		interval = "30"
		path = "/"
		port = "80"
		matcher = "200"
	}
}

resource "aws_alb_listener" "publiclistener" {
	load_balancer_arn = "${aws_alb.publicalb.arn}"
	port = "80"
	protocol = "HTTP"

	default_action {
		target_group_arn = "${aws_alb_target_group.initial_target_group.arn}"
		type = "forward"
	}

}

resource "aws_lb_target_group_attachment" "httpinstance" {
 count = "${var.count}"
 target_group_arn = "${aws_alb_target_group.initial_target_group.arn}"
 target_id        = "${element(aws_instance.albwebserver.*.id, count.index)}"
 port             = 80
}
