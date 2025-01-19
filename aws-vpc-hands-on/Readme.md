# VPS

## Private Subnets

### 1. **Create EC2 in Private Subnet**
- Create private subnet.
- Launch EC2 instance in the private subnet.
- Ensure that the instance does not have internet access and no public IP available. (using tools like `nc`)
- Ensure that you are unable to connect via SSH (using the key) due to lack of internet access.

---

## Public Subnets

- Create private subnet associating it with an Internet Gateway (IGW) and Routing Table
- Launch EC2 instance in the public subnet.

### **Connect Using Instance Connect**  
- Connect to the instance using the AWS Console's Instance Connect feature.
- Connect with SSH via Instance Connect.

### **Connect Using SSH**  
- SSH into the instance using the provided key pair:
```bash
ssh -i "my-testing-key-ec2.pem" ec2-user@<public_host>
```

### **Check Internet Connectivity**  
- From the instance, test internet access using:
  - `curl google.com`
  - `ping google.com`
- Both commands should return successful results, confirming internet access.


### **Verify Public Accessibility**  
- From a local machine, ping the public IP of the instance:
```bash
ping 18.156.136.162
```
- Instance should be accessible via the public IP.

### **Restrict certain Ports in Security Group**  
- Configure the instance's security group to allow only HTTP (80), HTTPS (443), and SSH (22).
- Run simple server on port 80
- Test port accessibility from local:
```bash
$ curl 18.156.136.162:80
# Current Datetime: 2025-01-05 10:49:00
# Host IP: 172.31.38.139

$ nc 18.156.136.162 22
# SSH-2.0-OpenSSH_8.7

$ nc 18.156.136.162 8080
# -
```


---

## Bastion Host

Recap: A Bastion Host is an instance used to securely access instances in a private subnet by acting as a bridge, typically via SSH, without exposing private instances directly to the internet.

- Create new EC2 instance in public subnet
- Allow SSH access (in SG) to Bastion Host
- Allow SSH access (in SG) of private instance from Bastion Host **private IP**
- SSH to Bastion Host (through public IP or create Elastic IP)
- SSH to private EC2 from Bastion Host
- Check private EC2 has no other Internet connection

---

## NAT Gateway

**Recap**: A NAT Gateway provides internet access to instances in a private subnet by routing traffic through a public subnet with internet access.

**Note**: You would likely want to delete NAT as it cost $0.045 per hour + data transfer

- Create NAT in public subnet (that has routed IGW) 
- Create Elastic IP and associated with NAT
- Route Elastic IP to the private subnet
- Connect to the EC2 in private subnet and check internet connectivity of private EC2

---
## VPC Endpoint
### VPC Interface Endpoint
#### EC2 to EC2
**Recap**: Provides access from AWS to AWS services through VPC
- Create new EC2 instance in public subnet
- Create new EC2 instance in private subnet
- **Assert**: SSH to public EC2 and check that connection private EC2 no possible
- Create VPC Endpoint with AWS Services for S3 (Interface)
- Select the VPC and subnet where your private EC2 resides
#### EC2 to AWS Secrets Manager


### VPC Gateway
#### EC2 to S3
Recap: Provide access from AWS to S3 and DynamoDB through VPC (without Private link and ENI)


---
## VPC Peering
## Transit VPN
## Connect with Session Manager
