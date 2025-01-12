# VPS

## Private Subnets

### 1. **Create EC2 in Private Subnet**
- Create private subnet.
- Launch EC2 instance in the private subnet.
- Ensure that the instance does not have internet access.
- Ensure that you are unable to connect via SSH due to lack of internet access.

---

## Public Subnets

### 2. **Create EC2 in Public Subnet**
- Create private subnet and create and associating it with an Internet Gateway (IGW) and Routing Table
- Launch EC2 instance in the public subnet.

#### 2.1 **Connect Using Instance Connect**  
- Connect to the instance using the AWS Console's Instance Connect feature.
- Connect with SSH via Instance Connect.


#### 2.2 **Connect Using SSH**  
- SSH into the instance using the provided key pair:
```bash
ssh -i "my-testing-key-ec2.pem" ec2-user@<public_host>
```
- Successful SSH connection to the instance.

#### 2.3 **Check Internet Connectivity**  
- From the instance, test internet access using:
  - `curl google.com`
  - `ping google.com`
- Both commands should return successful results, confirming internet access.


#### 2.4 **Verify Public Accessibility**  
- From a local machine, ping the public IP of the instance:
```bash
ping 18.156.136.162
```
- Instance should be accessible via the public IP.

#### 2.5 **Restrict certain Ports in Security Group**  
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

- Create new EC2 instance in public subnet
- Allow SSH access (SG) to Bastion Host
- Allow SSH access (SG) of private instance from Bastion Host **private IP**
- ✅ SSH to Bastion Host (through public IP or create Elastic IP)
- ✅ SSH to private EC2 from Bastion Host
- ✅ Check private EC2 has no Internet connection

---

## NAT Gateway

- Create NAT in public subnet (that has routed IGW) 
- Create Elastic IP and associated with NAT
- Route Elastic IP to the private subnet
- ✅Connect to the EC2 in private subnet and check internet connectivity of private EC2

---
## VPC Endpoint
## VPC Peering
## Transit VPN
## Egress-only
## Connect with Session Manager
