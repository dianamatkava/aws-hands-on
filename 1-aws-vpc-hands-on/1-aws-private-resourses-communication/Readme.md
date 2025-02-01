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


[//]: # (### VPC Interface Endpoint: EC2 Instance Connect Endpoin&#41;)

[//]: # (In this lab we will create a VPC Endpoint &#40;PrivateLink&#41; from expose secure direct connection &#40;without internet&#41; from public EC2 to private EC2. )

[//]: # ()
[//]: # (**Recap**: A VPC Interface Endpoint &#40;also known as PrivateLink&#41;.)

[//]: # ()
[//]: # (#### Prerequisites)

[//]: # (- you have EC2 instance in public subnet &#40;with public IP&#41; with it's owm SG)

[//]: # (- you have EC2 instance in private subnet &#40;with public IP&#41; with it's owm SG)

[//]: # ()
[//]: # (#### Tasks)

[//]: # (- Ensure that both EC2 instances have inbound rules &#40;in SG&#41; allowing ICMP traffic &#40;ping&#41;.)

[//]: # (- **Assert**: Check that connection private EC2 no possible using public IP `ping <public-ip-of-private-ec2>`)

[//]: # (- Create VPC Endpoint &#40;`VPC>PrivateLink and Lattice>Endpoint`&#41; type of _EC2 Instance Connect Endpoint_ &#40;free of charge&#41;)

[//]: # (- Select the VPC and subnet where your private EC2 resides)

[//]: # ()
[//]: # (#### Check)

[//]: # (- SSH to public EC2 through public IP.)

[//]: # (    - `ssh -i "my-testing-key-for-public-ec2.pem" ec2-user@<public-ip>`)

[//]: # (- Check public EC2 has connection to private EC2 `ping <private-ip-of-private-ec2>`)


### VPC Interface Endpoint: AWS services

In this lab we will create a VPC Endpoint (PrivateLink) for AWS Secrets Manager to allow private EC2 instances to securely access secrets from Secrets Manager without needing public internet access.

**Recap**: AWS Secrets Manager is a service for securely storing and managing sensitive information like API keys, database credentials, and other secrets.

**Note**: AWS Secrets Manager is not free of charge:
- Secrets Stored: $0.40 per confidential data unit per month
- API Calls: $0.05 per 10,000 API calls.

#### Prerequisites
- you have EC2 instance in private subnet (with public IP) with it's owm SG
- you have EC2 instance in public subnet which is also a Bastion Host to private EC2 with it's owm SG
- IAM for both instances allows read access to AWS Secrets Manager

#### Tasks
- Create new dummy key value pair in AWS Secrets Manager (Other type of secret)
- Create VPC Endpoint (`VPC>PrivateLink and Lattice>Endpoint`) type of _AWS Services_
- Select desired service from drop down list `com.amazonaws.<your-region>.secretsmanager`
- Select private subnet (should be the same where your private EC2 resides) in which to create the endpoint
- Create and assign a new security group (SG) to the VPC endpoint that allows inbound HTTPS traffic on port 443 from the **private EC2's SG**.

#### Check
- SSH to Bastion Host through public IP.
    - `ssh -i "my-testing-key-for-public-ec2.pem" ec2-user@<public-ip>`
- SSH to private EC2 from Bastion Host
  - `ssh -i "my-testing-key-for-bastion-host.pem" ec2-user@<private-ip>`
- Check private EC2 has no access to internet
  - `curl google.com`
- Check private EC2 can access secrets in AWS Secrets Manager
  - `aws secretsmanager get-secret-value --secret-id TEST_KEY  # returns key`
- Check that connection is private
  - `nslookup secretsmanager.eu-central-1.amazonaws.com  # returns private ip`
- Remove VPC Endpoint and try to access the key from private EC2
  - `aws secretsmanager get-secret-value --secret-id TEST_KEY  # no responce`

### VPC Gateway
#### EC2 to S3
Recap: Provide access from AWS to S3 and DynamoDB through VPC (without Private link and ENI)

#### Prerequisites
- you have EC2 instance in private subnet (with public IP) with it's owm SG
- you have EC2 instance in public subnet which is also a Bastion Host to private EC2 with it's owm SG

#### Tasks
- Create new dummy S3 bucket
- Add IAM for both instances to allow read access to private S3 bucket (block all public access)
- **Assert**: Connect to the private EC2 through the Bastion Host:
  - `aws s3 ls` # should fail due to the lack of internet access 
- Create VPC Endpoint (`VPC>"PrivateLink and Lattice">Endpoint`) type of _AWS Services_
- Select desired service from drop down list `com.amazonaws.<your-region>.s3 (Gateway)`
- Select your VPC and private route table. VPC Endpoint Gateway will automatically update the private route table to direct S3 traffic to the VPC endpoint. (If it did not happened authomatically you will have to manually update it.)

#### Check
- SSH to Bastion Host through public IP.
    - `ssh -i "my-testing-key-for-public-ec2.pem" ec2-user@<public-ip>`
- SSH to private EC2 from Bastion Host
  - `ssh -i "my-testing-key-for-bastion-host.pem" ec2-user@<private-ip>`
- Check private EC2 has no access to internet
  - `curl google.com`
- Check that instance can access S3 and return bucket list
  - `aws s3 ls`



---
## VPC Peering
## Transit VPN
## Connect with Session Manager
