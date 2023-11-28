module "aws-prod" {
  source         = "../../infra"
  instance       = "t2.micro"
  region         = "us-east-1"
  chave          = "iac-prod"
  security_group = "acesso-prod"
  nameGroup      = "asg_prod"
  min_size_asg   = 1
  max_size_asg   = 10
  prod           = true
}