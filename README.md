# tiered-application-aws
A multi-tier application in aws that has auto-scaling groups for front-end and back-end. Available in 3 availability zones

# TODO:
- Setup a ec2 instance with nginx for the front-end (Private network)
- Setup a ec2 instance with nginx for the back-end (Private network)
- Start RDS database (Private network)
- Configure instances so that the front-end and back-end can communicate (back-end can fetch data from RDS)
- User can access application through the browser (someone outside VPC)
- Once that works transform into AMIs