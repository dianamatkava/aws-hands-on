# VPS

## Private Subnets

### 1. **Create EC2 in Private Subnet**
   - **Action**: Create private subnet.
   - **Action**: Launch EC2 instance in the private subnet.
   - **Check**: Ensure that the instance does not have internet access.
   - **Result**: Unable to connect via SSH due to lack of internet access. ✅

---

## Public Subnets

### 2. **Create EC2 in Public Subnet**
- **Action**: Create private subnet and create and associating it with an Internet Gateway (IGW) and Routing Table
- **Action**: Launch EC2 instance in the public subnet.

#### 2.1 **Check Internet Connectivity**  
- **Action**: From the instance, test internet access using:
  - `curl google.com`
  - `ping google.com`
- **Expected Outcome**: Both commands should return successful results, confirming internet access. ✅

#### 2.2 **Connect Using Instance Connect**  
- **Action**: Connect to the instance using the AWS Console's Instance Connect feature.
- **Expected Outcome**: Successful SSH connection via Instance Connect. ✅

#### 2.3 **Connect Using SSH**  
- **Action**: SSH into the instance using the provided key pair:
```bash
ssh -i "my-testing-key-ec2.pem" ec2-user@<public_host>
```
- **Expected Outcome**: Successful SSH connection to the instance. ✅

#### 2.4 **Verify Public Accessibility**  
- **Action**: From a local machine, ping the public IP of the instance:
```bash
ping 18.156.136.162
```
- **Expected Outcome**: Instance should be accessible via the public IP. ✅

#### 2.5 **Restrict Security Group Ports**  
- **Action**: Configure the instance's security group to allow only HTTP (80), HTTPS (443), and SSH (22).
- **Expected Outcome**: The instance should only be accessible on these ports. ✅

#### 2.6 **Verify Port Accessibility**
- **Action**: Test port accessibility:
```bash
curl 18.156.136.162:80
```
Expected output:  
```
Current Datetime: 2025-01-05 10:49:00
Host IP: 172.31.38.139
```

```bash
nc 18.156.136.162 22
```
Expected output:  
```
SSH-2.0-OpenSSH_8.7
```

```bash
nc 18.156.136.162 8080
```
Expected output:  
```
-
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
