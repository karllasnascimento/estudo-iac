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

resource "aws_launch_template" "maquina" {
  image_id      = "ami-0230bd60aa48260c6"
  instance_type = var.instance
  key_name      = var.chave
  tags = {
    Name = "Study instance"
  }
  security_group_names = [var.security_group]

  user_data = var.prod ? filebase64("ansible.sh") : ""
}

resource "aws_autoscaling_group" "acg_group" {

  availability_zones = ["us-east-1a", "us-east-1b"]
  name               = var.nameGroup
  max_size           = var.max_size_asg
  min_size           = var.min_size_asg

  launch_template {
    id      = aws_launch_template.maquina.id
    version = "$Latest"
  }

  target_group_arns = var.prod ? [aws_lb_target_group.target_lb[0].arn] : []

}

resource "aws_default_subnet" "subnet_east-1a" {
  availability_zone = "us-east-1a"
}

resource "aws_default_subnet" "subnet_east-1b" {
  availability_zone = "us-east-1b"
}

resource "aws_lb" "load_balancer" {

  internal = false
  subnets  = [aws_default_subnet.subnet_east-1a.id, aws_default_subnet.subnet_east-1b.id]
  count    = var.prod ? 1 : 0

}

resource "aws_lb_target_group" "target_lb" {
  name     = "targetGroup"
  port     = "8000"
  protocol = "HTTP"
  vpc_id   = aws_default_vpc.default.id
  count    = var.prod ? 1 : 0
}

resource "aws_default_vpc" "default" {

}

resource "aws_lb_listener" "entry_lb" {

  load_balancer_arn = aws_lb.load_balancer[0].arn
  port              = "8000"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_lb[0].arn
  }
  count = var.prod ? 1 : 0
}

resource "aws_autoscaling_policy" "scale_prod" {

  name                   = "scale_prod"
  autoscaling_group_name = var.nameGroup
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
  count = var.prod ? 1 : 0
}


resource "aws_key_pair" "chaveSSH" {

  key_name   = var.chave
  public_key = file("${var.chave}.pub")

}
