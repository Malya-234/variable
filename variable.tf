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
  count         = var.{}
  ami           = var.{}
  instance_type = var.{}
  key           = var.{}
  security_grp  = var.{}
  subnet        = var.{}
  region        = var.{}
}
