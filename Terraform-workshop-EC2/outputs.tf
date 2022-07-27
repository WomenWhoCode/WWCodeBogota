output "app_server-ip" {value = aws_instance.app_server.public_ip }
output "app_server-dns" {value = aws_instance.app_server.public_dns }