terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "ec2_instance" {
  count         = var.{instance_count}
  ami           = var.{ami_id}
  instance_type = var.{instance_count}
  key           = var.{key_name}
  security_grp  = var.{sg_id}
  subnet        = var.{sg_id}
  region        = var.{reg}
}
