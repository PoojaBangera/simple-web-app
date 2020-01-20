data "aws_elb_hosted_zone_id" "elb_zone_id" {}

/*module "acm_certificate" {
  source  = "./certificate-module/"

  domain_name  = "elb.amazonaws.com"
  zone_id      = data.aws_elb_hosted_zone_id.elb_zone_id.id


  subject_alternative_names = [
    "*.elb.amazonaws.com",
    "*.us-east-1.elb.amazonaws.com"
  ]

  tags = {
    Name = "Hive App Certificate"
  }
}*/

/*resource "aws_route53_zone" "analytics" {
  vpc = {
    vpc_id = "aws_vpc.MY_VPC.id"
  }
  name   = "Private Zone"
}*/