## Create an IAM User

- 1. Create the User:
```shell
aws iam create-user --user-name TestUser
```

- 2. Create a Login Profile (for AWS Management Console access):
```shell
aws iam create-login-profile \
    --user-name TestUser \
    --password "pwd" \
    --password-reset-required
```


- 3. Create Access Keys (for programmatic access):
```shell
aws iam create-access-key --user-name TestUser
```


## IAM Policies
- First describe policy in json format
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::example-bucket"
        }
    ]
}
```

- Create the Policy:
```shell
aws iam create-policy \
    --policy-name ListS3BucketPolicy \
    --policy-document file://policy.json
```

- Attach the Policy to the User:
```shell
aws iam attach-user-policy \
    --user-name TestUser \
    --policy-arn arn:aws:iam::<account-id>:policy/ListS3BucketPolicy

```

## IAM Role for EC2
- Create a Trust Policy (save as trust-policy.json):
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": { "Service": "ec2.amazonaws.com" },
            "Action": "sts:AssumeRole"
        }
    ]
}
```
- Create the Role:
```shell
aws iam create-role \
    --role-name EC2S3ReadOnlyRole \
    --assume-role-policy-document file://trust-policy.json
```
- Attach the AWS Managed S3 Read-Only Policy:
```shell
aws iam attach-role-policy \
    --role-name EC2S3ReadOnlyRole \
    --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess
```

## List and Manage IAM Users
- List All IAM Users:
```shell
aws iam list-users --query 'Users[*].UserName'
```
- Update an Existing User’s Tags:
```shell
aws iam tag-user \
    --user-name TestUser \
    --tags Key=Department,Value=Engineering Key=Project,Value=Alpha
```

- Delete an IAM User (after detaching policies and removing keys):
```shell
aws iam delete-user --user-name TestUser
```