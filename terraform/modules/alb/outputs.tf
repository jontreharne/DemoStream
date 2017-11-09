output "webserverIP" {
  value = "${aws_instance.httpswebserver.*.public_ip}"
}
