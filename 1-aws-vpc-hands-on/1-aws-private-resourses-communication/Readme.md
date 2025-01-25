# VPC Private Resources Communication

## Bastion Host

**Recap**: A Bastion Host is an instance used to securely access instances in a private subnet by acting as a bridge, typically via SSH, without exposing private instances directly to the internet.

#### Tasks
- Create new EC2 instance in private subnet and allow public ip (in advanced network settings or attach Elastic IP later)
- Create new EC2 instance in public subnet (from `0-aws-subnets` lab) and name as Bastion Host
- Allow SSH access (in SG) to Bastion Host
- Allow SSH access (in SG) of private instance from Bastion Host **private IP**

#### Check
- SSH to Bastion Host (through public IP or create Elastic IP).
    - `ssh -i "my-testing-key-for-bastion-host.pem" ec2-user@<public-ip>`
- SSH to private EC2 from Bastion Host
  - `ssh -i "my-testing-key-for-bastion-host.pem" ec2-user@<private-ip>`
- Check private EC2 has no other Internet connection `curl google.com`
- Check that SSH connection from your local machine can not be established to EC2 in private subnet by its **public-ip**

---

## NAT Gateway

**Recap**: A NAT Gateway provides internet access to instances in a private subnet by routing traffic through a public subnet with internet access.

**Note**: You would likely want to delete NAT as it cost $0.045 per hour + data transfer

#### Tasks
- Create NAT in public subnet (that has routed IGW) 
- Create Elastic IP and associated with NAT
- Route Elastic IP to the private subnet

#### Check
- Connect to the EC2 in private subnet and check internet connectivity of private EC2 `curl google.com`

---

## VPC Endpoint

**Recap**: Provides access from AWS to AWS services through VPC without exposing traffic to the public internet. 
**Common Use Cases**: 
- Amazon EC2 Systems Manager (SSM): Secure access to Systems Manager for managing instances without using a public IP or NAT gateway.
- AWS Lambda: Direct, private access to Lambda functions within your VPC for security and compliance reasons.
- Amazon Kinesis: Private connections for Kinesis Data Streams and Firehose to handle data streaming securely within your VPC. 
- AWS CloudWatch: Private access to CloudWatch logs, metrics, and alarms within the VPC, improving security.
- AWS Secrets Manager: accessing Secrets Manager privately within your VPC to keep sensitive information secure.


### VPC Interface Endpoint: EC2 Instance Connect Endpoin)
EC2 to EC2

**Recap**: A VPC Interface Endpoint (also known as PrivateLink).

#### Prerequisites
- you have EC2 instance in public subnet (allow public IP)
- you have EC2 instance in private subnet (allow public IP)

#### Tasks
- Ensure that both EC2 instances have inbound rules (in SG) allowing ICMP traffic (ping).
- **Assert**: Check that connection private EC2 no possible using public IP `ping <public-ip-of-private-ec2>`
- Create VPC Endpoint (`VPC>PrivateLink and Lattice>Endpoint`) type of _EC2 Instance Connect Endpoint_ (free of charge)
- Select the VPC and subnet where your private EC2 resides

#### Check
- SSH to public EC2 through public IP.
    - `ssh -i "my-testing-key-for-public-ec2.pem" ec2-user@<public-ip>`
- Check public EC2 has connection to private EC2 `ping <private-ip-of-private-ec2>`


### VPC Interface Endpoint: AWS services

In this lab we will create a VPC Endpoint (PrivateLink) for AWS Secrets Manager to allow private EC2 instances to securely access secrets from Secrets Manager without needing public internet access.

**Recap**: AWS Secrets Manager is a service for securely storing and managing sensitive information like API keys, database credentials, and other secrets.
**Note**: AWS Secrets Manager is not free of charge:
- Secrets Stored: $0.40 per confidential data unit per month
- API Calls: $0.05 per 10,000 API calls.

#### Prerequisites
- you have EC2 instance in private subnet (allow public IP)
- you have EC2 instance in public subnet which is also a Bastion Host to private EC2

#### Tasks
- Create new dummy key value pair in AWS Secrets Manager (Other type of secret)
- Create VPC Endpoint (`VPC>PrivateLink and Lattice>Endpoint`) type of _AWS Services_
- Select desired service from drop down list `com.amazonaws.<your-region>.secretsmanager`
- Select private subnet in which to create the endpoint

#### Check
- SSH to Bastion Host through public IP.
    - `ssh -i "my-testing-key-for-public-ec2.pem" ec2-user@<public-ip>`
- Check public EC2 can not access secrets in AWS Secrets Manager
- SSH to private EC2 from Bastion Host
  - `ssh -i "my-testing-key-for-bastion-host.pem" ec2-user@<private-ip>`


### VPC Gateway
#### EC2 to S3
Recap: Provide access from AWS to S3 and DynamoDB through VPC (without Private link and ENI)


---
## VPC Peering
## Transit VPN
## Connect with Session Manager
