output "webserverIP" {
  value = "${aws_instance.albwebserver.*.private_ip}"
}
output "initial_target_group" {
	value = "${aws_alb_target_group.initial_target_group.arn}"
}
