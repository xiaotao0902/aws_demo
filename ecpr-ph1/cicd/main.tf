provider "aws" {
	region     = "${var.aws_region}"
}

terraform {
	required_version = ">= 0.11.11"
	backend "local" {
		path=".terraform/terraform.tfstate"

	}
}