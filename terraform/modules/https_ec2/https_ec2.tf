
data "aws_security_group" "httpswebserver_sg" {
  name = "httpswebserver_sg"
}
data "aws_security_group" "ssh_sg" {
  name = "ssh_sg"
}

data "aws_route53_zone" "jws-awsome-domain" {
  name = "jws-awsome-domain.co.uk."
}

resource "aws_eip" "httpswebserver-public-eip" {
  count = "${var.count}"
  vpc = true

  network_interface = "${element(aws_network_interface.httpswebserver-nic.*.id,count.index)}"
}

resource "aws_route53_record" "httpswebserver" {
  count = "${var.count}"
  zone_id = "${data.aws_route53_zone.jws-awsome-domain.zone_id}"
  name    = "demoserver${count.index}.jws-awsome-domain.co.uk"
  type    = "A"
  ttl     = "60"
  records = ["${element(aws_eip.httpswebserver-public-eip.*.public_ip,count.index)}"]
}

resource "aws_network_interface" "httpswebserver-nic" {
 count = "${var.count}"
 subnet_id       = "subnet-ccf75281"
 security_groups = ["${data.aws_security_group.httpswebserver_sg.id}","${data.aws_security_group.ssh_sg.id}"]

 tags {
   Name = "HTTPSWebServer.${count.index}"
 }
}

resource "aws_instance" "httpswebserver" {
  count = "${var.count}"
  ami           = "ami-1a7f6d7e"
  instance_type = "t2.micro"
  key_name  = "${var.keypair}"

  network_interface {
       network_interface_id = "${element(aws_network_interface.httpswebserver-nic.*.id,count.index)}"
       device_index = 0
  }

  connection {
          user = "ec2-user"
          private_key = "${file("~/.ssh/AWS-WebServers-KeyPair.pem")}"
  }

  tags {
    Name = "HTTPSWebServer.${count.index}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo echo demoserver${count.index}.jws-awsome-domain.co.uk > /tmp/myhostname",
    ]
  }

  provisioner "file" {
    source      = "bootstraps/https_webserver.sh"
    destination = "/tmp/https_webserver.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/https_webserver.sh",
      "sudo /tmp/https_webserver.sh",
    ]
  }

  provisioner "file" {
    source      = "bootstraps/https_certbot.sh"
    destination = "/tmp/https_certbot.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/https_certbot.sh",
      "/tmp/https_certbot.sh",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "sudo reboot",
    ]
  }
}
