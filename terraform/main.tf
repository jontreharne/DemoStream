variable aws_access_key {}
variable aws_secret_key {}

# Configure the AWS Provider
provider "aws" {
  region     = "eu-west-2"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

module "security" {
  source = "modules/security"
}

module "website_ec2" {
  source = "modules/website_ec2"
  count = 1
  keypair = "AWS-WebServers-KeyPair"
}

module "http_ec2" {
  source = "modules/http_ec2"
  count = 0
  keypair = "AWS-WebServers-KeyPair"
}

module "https_ec2" {
  source = "modules/https_ec2"
  count = 0
  keypair = "AWS-WebServers-KeyPair"
}
