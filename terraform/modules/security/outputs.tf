output "httpswebserver_sg" {
  value = "${aws_security_group.httpswebserver_sg.id}"
}
output "httpwebserver_sg" {
  value = "${aws_security_group.httpwebserver_sg.id}"
}
output "ssh_sg" {
  value = "${aws_security_group.ssh_sg.id}"
}
