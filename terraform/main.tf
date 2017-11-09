# Configure the AWS Provider
provider "aws" {
  region = "${var.aws_default_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

module "vpc" {
	source = "modules/vpc"
	vpc_range = "${var.vpc_range}"
}

module "iam" {
	source = "modules/iam"
}

module "subnets" {
	source = "modules/subnets"
	vpc_id = "${module.vpc.vpc_id}"
	public_subnet_map = "${var.public_subnet_map}"
	private_subnet_map = "${var.private_subnet_map}"
}

module "igw" {
	source = "modules/igw"
	vpc_id = "${module.vpc.vpc_id}"
}

module "eip" {
	source = "./modules/eip"
}

module "ngw" {
	source = "modules/ngw"
	ngweipid = "${module.eip.ngweipid}"
	public_subnets = "${module.subnets.public_subnets}"
}

module "route_tables" {
	source = "modules/route_tables"
	vpc_id = "${module.vpc.vpc_id}"
	public_subnet_map = "${var.public_subnet_map}"
	private_subnet_map = "${var.private_subnet_map}"
	public_subnets = "${module.subnets.public_subnets}"
	private_subnets = "${module.subnets.private_subnets}"
	ngwid = "${module.ngw.ngwid}"
	igwid = "${module.igw.igwid}"
}

module "alb" {
	source = "modules/alb"
	public_subnets = "${module.subnets.public_subnets}"
	vpc_id = "${module.vpc.vpc_id}"
  private_subnets = "${module.subnets.private_subnets}"
  availability_zones = "${var.availability_zones}"
  keypair = "AWS-WebServers-KeyPair"
  count = 1
  httpswebserver_sg = "${module.security.httpswebserver_sg}"
  httpwebserver_sg = "${module.security.httpwebserver_sg}"
  ssh_sg = "${module.security.ssh_sg}"
  managerprofile = "${module.iam.managerprofile}"
}


module "security" {
  source = "modules/security"
  vpc_id = "${module.vpc.vpc_id}"
}

module "https_ec2" {
  source = "modules/https_ec2"
  count = 1
  keypair = "AWS-WebServers-KeyPair"
  httpswebserver_sg = "${module.security.httpswebserver_sg}"
  ssh_sg = "${module.security.ssh_sg}"
  public_subnets = "${module.subnets.public_subnets}"
}

module "http_ec2" {
  source = "modules/http_ec2"
  count = 2
  keypair = "AWS-WebServers-KeyPair"
  availability_zones = "${var.availability_zones}"
  private_subnets = "${module.subnets.private_subnets}"
  httpwebserver_sg = "${module.security.httpwebserver_sg}"
  ssh_sg = "${module.security.ssh_sg}"
}
