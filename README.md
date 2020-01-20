# simple-web-app

This app uses a small Dockerized node-js web app and uses solely AWS resources to spin up using terraform.

Features:

● All AWS services defined and provisioned using Terraform. 
● Highly available across two availability zones in a single region.
● Autoscaling, spun inside a VPC, in two separate subnets
● Health check available at the application level using cloud watch and also application load balancer level.
● Highly available across two availability zones in a single region.
