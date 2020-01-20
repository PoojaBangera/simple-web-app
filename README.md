# simple-web-app

This app uses a small Dockerized node-js web app and uses solely AWS resources to spin up using terraform.

Features:

● All AWS services defined and provisioned using Terraform. 
● Highly available across two availability zones in a single region.
● Autoscaling, spun inside a VPC, in two separate subnets
● Health check available at the application level using cloud watch and also application load balancer level.
● Highly available across two availability zones in a single region.




Instructions to run:

Pre-requisites:  
1. AWS CLI installed, configured with your access key and ID.
2.  Keep your Root ARN noted-> replace value of “AWS” in s3-policy-lb.json , line 8 with the value in quotes.
3. Create a backend s3 bucket-> name it as foojis3bucket to store the state file versions.
4.  A name for your keypair 
Run the following commands:
  • terraform init
  • terraform apply
    o Enter a name for your keypair 
    if at this stage you receive the following error: 
    Error: Provider produced inconsistent final plan 
When expanding the plan for aws_autoscaling_group.bar to include new values 
learned so far during apply, provider "registry.terraform.io/-/aws" produced 
an invalid new value for .availability_zones: was known, but now unknown. 
This is a bug in the provider, which should be reported in the provider's own 
issue tracker. 
run terraform apply again. 


Result: 
Go to the load balancer console and retrieve the  load Balancer DNS name and append it with a  
/healthcheck 
/hive. 
example: test-alb-tf-1008534428.us-east-1.elb.amazonaws.com/healthcheck 
test-alb-tf-1008534428.us-east-1.elb.amazonaws.com/hive 
You should receive the expected status messages respectively. 
{"status":"up","uptime":116.943} 
{"foo":"bar"}
