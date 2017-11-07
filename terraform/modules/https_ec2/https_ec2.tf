resource "aws_instance" "httpswebserver" {
  count = "${var.count}"
  ami           = "ami-1a7f6d7e"
  instance_type = "t2.micro"
  key_name  = "${var.keypair}"

  connection {
          user = "ec2-user"
          private_key = "${file("~/.ssh/AWS-WebServers-KeyPair.pem")}"
      }

  security_groups = ["httpswebserver_sg","ssh_sg"]

  tags {
    Name = "HTTPSWebServer.${count.index}"
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
}
