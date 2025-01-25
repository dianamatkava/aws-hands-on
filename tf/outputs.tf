output "my_testing_ec2_public_ip" {
  value = aws_instance.my_testing_ec2_public_1.public_ip
}

output "my_testing_ec2_private_ip" {
  value = aws_instance.my_testing_ec2_private_1.private_ip
}
