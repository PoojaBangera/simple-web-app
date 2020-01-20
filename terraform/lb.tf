resource "aws_lb" "alb" {
  name = "test-alb-tf"
  internal = false
  load_balancer_type = "application"
  security_groups = [
    aws_security_group.My_ALB_Security_Group.id,
    aws_security_group.My_VPC_Security_Group.id]
  subnets = [
    aws_subnet.My_VPC_Subnet1.id,
    aws_subnet.My_VPC_Subnet2.id]
  idle_timeout = 300
  enable_deletion_protection = false

  access_logs {
    bucket = "fooji-s3-alb-logs"
    prefix = "test-alb"
    enabled = true
  }


  #instances = ["aws_instance.ec2-sub-1.id","aws_instance.ec2-sub-2.id"]
  enable_cross_zone_load_balancing = true

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "alb-target" {
  name = "alb-target-group"
  port = 3000
  protocol = "HTTP"
  vpc_id = aws_vpc.My_VPC.id
}
/*
resource "aws_lb_target_group_attachment" "snet-1" {
  target_group_arn = aws_lb_target_group.alb-target.arn
  target_id        = aws_autoscaling_group.bar.name
  port             = 3000
}*/
/*
resource "aws_lb_target_group_attachment" "snet-2" {
  target_group_arn = aws_lb_target_group.alb-target.arn
  target_id        = aws_instance.ec2-sub-2.id
  port             = 3000
}
*/
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port = "80"
  protocol = "HTTP"
  #port              = "443"
  #protocol          = "HTTPS"
  #certificate_arn = module.acm_certificate.this_acm_certificate_arn

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb-target.arn
  }
}


resource "aws_lb_listener_rule" "static" {
  listener_arn = aws_lb_listener.alb_listener.arn
  priority = 100

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb-target.arn
  }
  condition {

    path_pattern {
      values = [
        "*/hive",
        "*/healthcheck"]
    }
  }
}
resource aws_security_group "My_ALB_Security_Group" {
  vpc_id = aws_vpc.My_VPC.id
  name = "lb_sg"
  description = "All traffic to and from ALB"
  #security_group_id = "sg-alb-111"

  # allow ingress of port 22
  ingress {
    cidr_blocks = var.ingressCIDRblock
    from_port = 22
    to_port = 22
    protocol = "TCP"
  }
  ingress {
    cidr_blocks = var.ingressCIDRblock
    from_port = 80
    to_port = 80
    protocol = "TCP"
  }

  ingress {
    cidr_blocks = var.ingressCIDRblock
    from_port = 443
    to_port = 443
    protocol = "TCP"
  }
  ingress {
    cidr_blocks = var.ingressCIDRblock
    from_port = 3000
    to_port = 3000
    protocol = "TCP"
  }

  # allow egress of all ports
  egress {
    from_port = 443
    to_port = 443
    protocol = "TCP"
    cidr_blocks = [
      "0.0.0.0/0"]

  }
  egress {
    from_port = 3000
    to_port = 3000
    protocol = "TCP"
    cidr_blocks = [
      "0.0.0.0/0"]

  }
  tags = {
    Name = "My ALB Security Group"
    Description = "My ALB Security Group"
  }
}