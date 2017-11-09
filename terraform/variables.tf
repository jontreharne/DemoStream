variable "subnets" {
  description = "Run the EC2 Instances in these Subnets"
  type = "list"
  default = ["subnet-ccf75281", "subnet-c064ebbb"]
}
variable "zones" {
  description = "Run the EC2 Instances in these Availability Zones"
  type = "list"
  default = ["eu-west-2a", "eu-west-2b"]
}
