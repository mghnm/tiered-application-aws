output "bastion_ips" {
  value = zipmap(aws_instance.bastions.*.tags.Name, aws_instance.bastions.*.public_ip)
  description = "Bastion public ip addresses."
}

# output "bastion_ips" {
#   value = aws_instance.bastions.*.tags.Name
#   description = "Bastion public ip addresses."
# }