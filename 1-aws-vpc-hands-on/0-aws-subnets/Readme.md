# VPS

1. [VPC Subnets](Readme.md)
   1. [Private Subnet](Readme.md#1-private-subnets)
   2. [Public Subnets](Readme.md#2-public-subnets)
   3. [Restrict Certain Ports, IPs](Readme.md#3-restrict-certain-ports-in-security-group-)

## 1. Private Subnets

### **Create EC2 in Private Subnet**

#### Tasks
- Create private subnet.
- Launch EC2 instance in the private subnet.

#### Check
- Ensure no public IP exposed
- Ensure that the instance does not have internet access. (you can use tools like `nc`)
- Ensure that you are unable to connect via SSH (using the key), via Instance Connect, AWS Console or Terminus.

---

## 2. Public Subnets

#### Tasks
- Create private subnet and associate it with an Internet Gateway (IGW) and Routing Table
- Launch new EC2 instance in the public subnet.

#### Check
- Connect to the instance using the AWS Console's Instance Connect feature.
- SSH into the instance using the provided key pair:
```bash
ssh -i "my-testing-key-ec2.pem" ec2-user@<public_host>
```

#### **Check Internet Connectivity**  
- From the instance, test internet access using (Both commands should return successful results, confirming internet access.):
  - `curl google.com` or `ping google.com`


#### **Verify Public Accessibility**  
- From a local machine, ping the public IP of the instance (Instance should be accessible via the public IP.):
```bash
ping 18.156.136.162
```

## **3. Restrict certain Ports in Security Group**  

#### Tasks
- Configure the instance's security group to allow only HTTP (80), HTTPS (443), and SSH (22).
- Run simple server on port 80 using python or node.js server.


#### Check
- Test port accessibility from local:
```bash
$ curl <public-ip>:80
# Current Datetime: 2025-01-05 10:49:00
# Host IP: <host-ip>

$ nc <public-ip> 22
# SSH-2.0-OpenSSH_8.7

$ nc <public-ip> 8080
# -
```
