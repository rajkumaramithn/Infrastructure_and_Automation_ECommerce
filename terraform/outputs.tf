output "ec2_public_ip" {
  description = "Public IP address of the ecommerce server"
  value       = aws_instance.ecommerce.public_ip
}

output "ec2_public_dns" {
  description = "Public DNS name of the ecommerce server"
  value       = aws_instance.ecommerce.public_dns
}

output "frontend_url" {
  description = "Frontend URL"
  value       = "http://${aws_instance.ecommerce.public_ip}:3000"
}