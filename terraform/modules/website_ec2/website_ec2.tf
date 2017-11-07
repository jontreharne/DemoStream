resource "aws_instance" "websitewebserver" {
  count = "${var.count}"
  ami           = "ami-1a7f6d7e"
  instance_type = "t2.micro"
  key_name  = "${var.keypair}"

  connection {
          user = "ec2-user"
          private_key = "${file("~/.ssh/AWS-WebServers-KeyPair.pem")}"
      }

  security_groups = ["httpwebserver_sg","ssh_sg"]

  tags {
    Name = "WebsiteWebServer.${count.index}"
  }

  provisioner "file" {
    source      = "bootstraps/website_webserver.sh"
    destination = "/tmp/website_webserver.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/website_webserver.sh",
      "sudo /tmp/website_webserver.sh",
    ]
  }
}
