module "aws-dev" {
  source   = "../../infra"
  instance = "t2.micro"
  region   = "us-east-1"
  chave    = "iac-dev"
}

