# This block ddefines the  output values that will be displayed  after the terraform  apply command executed. (display list of the public IP addresses and security group id that created)
output "instance_public_ips" {
  value = [for instance in aws_instance.ubuntu : instance.public_ip]
}

output "database_security_group_id" {
  value = aws_security_group.database_security_group.id
}
