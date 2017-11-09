data "aws_route53_zone" "jws-awsome-domain" {
  name = "jws-awsome-domain.co.uk."
}

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

  vpc_security_group_ids = ["${var.httpswebserver_sg}","${var.ssh_sg}","${var.httpwebserver_sg}"]

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

  provisioner "remote-exec" {
    inline = [
      "sudo echo www.jws-awsome-domain.co.uk > /tmp/myhostname",
    ]
  }

  provisioner "file" {
    source      = "bootstraps/alb_certbot.sh"
    destination = "/tmp/alb_certbot.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/alb_certbot.sh",
      "sudo /tmp/alb_certbot.sh",
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

data "aws_iam_server_certificate" "maindomain" {
 count = "${var.run ? 1 : 0}"
 name_prefix   = "www.jws-awsome-domain.co.uk"
 statuses = ["ISSUED"]
}

resource "aws_alb_listener" "publictlslistener" {
  count = "${var.run ? 1 : 0}"
	load_balancer_arn = "${aws_alb.publicalb.arn}"
	port = "443"
	protocol = "HTTPS"
  certificate_arn = "${data.aws_iam_server_certificate.maindomain.arn}"

	default_action {
		target_group_arn = "${aws_alb_target_group.initial_target_group.arn}"
		type = "forward"
	}

}

resource "aws_route53_record" "albwebserver" {
  zone_id = "${data.aws_route53_zone.jws-awsome-domain.zone_id}"
  name    = "www.jws-awsome-domain.co.uk"
  type    = "A"
  alias {
    name = "${aws_alb.publicalb.dns_name}"
    zone_id = "${aws_alb.publicalb.zone_id}"
    evaluate_target_health = true
  }
}
