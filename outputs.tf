#output block that will give us alb dns name to verify connection
output "alb_public_url" {
  description = "Public URL for Application Load Balancer"
  value       = aws_lb.alb-project.dns_name
}