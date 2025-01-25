```yaml
my-testing-vpc:
 igw: my-testing-igw  # :121 (relationship)
 acl: acl-019a901bc4baa5465
 
 subnets:
  my-testing-private-subnet-1a:
     cidr: 10.0.0.0/28
  my-testing-public-subnet-1b:
     cidr: 10.0.0.16/28
             
 rtb:
  type: default
  rtb-079c2a8c7584684f2:
    explicit-subnet-associations:
     - my-testing-public-subnet-1b	


my-testing-nat-gateway:
   vpc: my-testing-vpc
   subnet: my-testing-public-subnet-1b
   eip: 18.199.54.175
   
				
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
