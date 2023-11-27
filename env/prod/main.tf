module "aws-prod" {
  source = "../../infra"
  instance = "t2.micro"
  region = "us-east-1"
  chave = "iac-prod"
  security_group = "acesso-prod"
}