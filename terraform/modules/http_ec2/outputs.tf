output "webserverIP" {
  value = "${aws_instance.httpwebserver.*.public_ip}"
}
