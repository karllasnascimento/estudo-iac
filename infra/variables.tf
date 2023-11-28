variable "region" {
  type = string
}

variable "chave" {
  type = string
}

variable "instance" {
  type = string
}

variable "profile" {
  type    = string
  default = "estudoterraform"
}

variable "security_group" {
  type = string
}

variable "nameGroup" {
  type = string

}

variable "max_size_asg" {

  type = number

}

variable "min_size_asg" {

  type = number

}

variable "prod" {
  type = bool
}