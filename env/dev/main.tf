module "aws-dev" {
  source         = "../../infra"
  instance       = "t2.micro"
  region         = "us-east-1"
  chave          = "iac-dev"
  security_group = "acesso_dev"
  nameGroup      = "asg_dev"
  max_size_asg   = 1
  min_size_asg   = 0
  prod           = false
}
