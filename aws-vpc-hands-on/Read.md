```yaml
sg:
 launch-wizard-1:
  in: 
   - http:*:80
   - htts:*:443
   - ssh:*:22
  out: 
   - ssh:*:22
         
 my-testing-sg:
  in: 
   - ssh:*:22
  out: 
   - ssh:*:22
```

```yaml
my-testing-vpc:
 igw: my-testing-igw  # :121 (relationship)
 acl: acl-019a901bc4baa5465
 
 subnets:
  - my-testing-private-subnet-1a
  - my-testing-public-subnet-1b
             
 rtb:
  type: default
  rtb-079c2a8c7584684f2:
    explicit-subnet-associations:
     - my-testing-public-subnet-1b
	

				
ec2:
 - my-testing-ec2-public-1:
     sg: launch-wizard-1  # auto created
     
     subnet: my-testing-public-subnet-1b  # resides in eu-cental-1b
     ssh-key: my-testing-key
     
     private-IPv4: 172.31.38.139
     public-IPv4: 18.156.136.162
     
     connectivity: 
      - ssh
      - aws-instance-connect  # aws ui console
      - ${private-connectivity}
     
     
 - my-testing-ec2-private-1:
     sg: my-testing-sg
     
     subnet: my-testing-private-subnet-1a # resides in eu-cental-1a
     ssh-key: my-testing-key
     
     private-IPv4: 10.0.0.12
     public-IPv4: null
  
     connectivity: 
      - ${private-connectivity}

private-connectivity:
 - bastion-host
 - vpn
 - session-manager
```

### VPS

1. Create `my-testing-ec2-private-1` in private subnet `my-testing-private-subnet-1a`
    1. check does not have internet access (and can not connect via ssh) ✅
2. Create `my-testing-ec2-public-1` in public subnet `my-testing-public-subnet-1b`.
    1. check internet connection from instance `curl [google.com](http://google.com)` , `ping google.com`  ✅
    2. connect with Instance Connect ✅
    3. connect with SSH `ssh -i "my-testing-key-ec2.pem" [ec2-user@](mailto:ec2-user@10.0.0.12)<public_host>` ✅
    4. Check is public: access from local `ping 18.156.136.162` ✅
    5. Allow only port 443, 80 HTTP and 22 SSH ✅
    ```bash
   curl 18.156.136.162:80
   Current Datetime: 2025-01-05 10:49:00<br>Host IP: 172.31.38.139
   
   nc 18.156.136.162 22
   SSH-2.0-OpenSSH_8.7
   
   nc 18.156.136.162 8080
   -
    ```
3. Create `my-testing-ec2_private_1` in private subnet_3
    1. Connect via VPN
    2. Bastion Host
    3. Session Manager