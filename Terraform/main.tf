terraform { 
  required_version = ">=1.3.10"
}


resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0" # Replace with your desired AMI
  instance_type = "t2.micro"
  security_groups = ["sg-0123456789"]
}

resource "aws_security_group" "web_server_sg" {
  name        = "web-server-sg"
  description = "Security group for web servers"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "web_server_lb" {
  scheme = "internet-facing"
  type   = "application"

  listener {
    load_balancer_port      = 443
    instance_port          = 443
    protocol              = "tcp"
    certificate_arn        = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-9abc-defg-hijk-123456789012" # Replace with your certificate ARN
  }

  security_groups = ["sg-0123456789"]
}

resource "aws_lb_target_group" "web_server_tg" {
  name        = "web-server-tg"
  target_type = "instance"
  port        = 443
  protocol    = "tcp"
}
