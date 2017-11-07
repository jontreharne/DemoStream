output "websiteIP" {
  value = "${aws_instance.websitewebserver.*.public_ip}"
}
