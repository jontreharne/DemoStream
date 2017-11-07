resource "aws_instance" "httpwebserver" {
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
    Name = "HTTPWebServer.${count.index}"
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
