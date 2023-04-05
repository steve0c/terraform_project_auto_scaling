


#creating a s3 bucket 
resource "aws_s3_bucket" "project_s3" {
  bucket = var.s3_bucket
}

#attaching a bucket policy to give terraform permissions
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = var.s3_bucket
  policy = file("policy.json")
}

#ebabeling bucket versioning for recovery
resource "aws_s3_bucket_versioning" "project_versioning" {
  bucket = aws_s3_bucket.project_s3.id
  versioning_configuration {
    status = "Enabled"
  }
}

#seeting the acl of the bucket to private
resource "aws_s3_bucket_acl" "project_acl" {
  bucket = aws_s3_bucket.project_s3.id
  acl    = "private"
}


#creating a launch template with ubuntu ami and script for install
resource "aws_launch_template" "launch_template" {
  name                   = "launch_template"
  image_id               = var.ami_id
  instance_type          = var.instance_type
  user_data              = filebase64("apache.sh")
  vpc_security_group_ids = [aws_security_group.project-sg1.id]
}

#creating an auto scaling group
resource "aws_autoscaling_group" "asg_group" {
  name               = "asg_group"
  min_size           = 2
  max_size           = 5
  availability_zones = [var.availability_zone_a, var.availability_zone_b]
  target_group_arns = [aws_lb_target_group.alb-targetgroup.arn]


  launch_template {
    id = aws_launch_template.launch_template.id 
    version = "$Latest"
  }
}

#creating an application load balancer
resource "aws_lb" "alb-project" {
  name               = "alb-project"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = ["subnet-026b3cb418d28e844", "subnet-0f9cfcd126a7dcfa7"]

}

#configuring and creating the listener for the lb
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb-project.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-targetgroup.arn
  }
}


#creating the alb target group
resource "aws_lb_target_group" "alb-targetgroup" {
  name        = "alb-targetgroup"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
}

#security gorup for the application load balancer
#allowing http and https
resource "aws_security_group" "alb-sg" {
  name        = "alb-sg"
  description = "Allow traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.cidr_open]
  }

  ingress {
    description = "https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.cidr_open]
  }
   egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_open]
  }
}

#scurity group for launch_template
#allowing http and ssh
resource "aws_security_group" "project-sg1" {
  name        = "project-sg1"
  description = "Allow traffic"
  vpc_id      = var.vpc_id


  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.cidr_vpc]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.cidr_open]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_open]
  }
}



  