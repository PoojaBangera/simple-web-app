data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = [
      "ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values = [
      "hvm"]
  }

  owners = [
    "099720109477"]
  # Canonical
}


resource "aws_launch_template" "launchtemplate" {
  name_prefix = "launchtemplate"
  image_id = "ami-0bfb5f753b6c2d30b"
  instance_type = "t2.micro"
}

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.example.public_key_openssh
}

resource "aws_placement_group" "web" {
  name = "my-ec2-placement-group"
  strategy = "spread"
}
resource "aws_autoscaling_group" "bar" {
  availability_zones = [
    "us-east-1a",
    "us-east-1b"]
  desired_capacity = 2
  max_size = 2
  min_size = 1
  placement_group = aws_placement_group.web.id
  vpc_zone_identifier = [
    aws_subnet.My_VPC_Subnet1.id,
    aws_subnet.My_VPC_Subnet2.id]
  health_check_type = "ELB"
  launch_configuration = aws_launch_configuration.ubuntu_lc.name

  /*
  launch_template {
    id      = aws_launch_template.launchtemplate.id
    version = "$Latest"
  }
*/
}

resource "aws_launch_configuration" "ubuntu_lc" {
  name = "ubuntu-lc"
  image_id = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  iam_instance_profile = "HiveAdmin"
  security_groups = [
    aws_security_group.My_VPC_Security_Group.id]
  key_name = aws_key_pair.generated_key.key_name
  user_data = data.template_file.user_data_init.rendered

}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.bar.id
  alb_target_group_arn = aws_lb_target_group.alb-target.arn
}

data "template_file" "user_data_init" {
  template = file("hive.sh")

  vars = {
    #auto_scaling_group_name = aws_autoscaling_group.bar.name
    auto_scaling_group_name = "Hive_App_ASG"
  }
}
/*

resource "aws_instance" "ec2-sub-1" {
  ami = "ami-0bfb5f753b6c2d30b"
  instance_type = "t2.micro"
  #instance_id = "i-instanceid"
  subnet_id=aws_subnet.My_VPC_Subnet1.id
  security_groups    = [aws_security_group.My_VPC_Security_Group.id]
  key_name = "ec2-subnet-1"
  iam_instance_profile = "HiveAdmin"
  #placement_group = aws_placement_group.web.id
  user_data = data.template_file.user_data_init.rendered
}

resource  "aws_instance" "ec2-sub-2" {
  ami = "ami-0bfb5f753b6c2d30b"
  instance_type = "t2.micro"
  #instance_id = "i-instanceid"
  subnet_id=aws_subnet.My_VPC_Subnet2.id
  security_groups    = [aws_security_group.My_VPC_Security_Group.id]
  iam_instance_profile = "HiveAdmin"
  #placement_group = aws_placement_group.web.id
  key_name = "ec2-subnet-1"
  user_data = data.template_file.user_data_init.rendered
}
*/
