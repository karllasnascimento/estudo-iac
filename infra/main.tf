terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = var.profile
  region  = var.region
}

resource "aws_instance" "app_server" {
  ami           = "ami-0230bd60aa48260c6"
  instance_type = var.instance
  key_name = var.chave
  tags = {
    Name = "Study instance"
  }
}

resource "aws_key_pair" "chaveSSH" {

    key_name = var.chave
    public_key = file("${var.chave}.pub")

}