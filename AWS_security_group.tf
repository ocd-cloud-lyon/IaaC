resource "aws_default_security_group" "default" {
   vpc_id      = "vpc-03cca642ef84627e2"
 ingress {
     from_port   = 0
     to_port     = 0
     protocol    = "-1"
     # Please restrict your ingress to only necessary IPs and ports.
     # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
     cidr_blocks     = ["0.0.0.0/0"]
   }
 egress {
     from_port       = 0
     to_port         = 0
     protocol        = "-1"
     cidr_blocks     = ["0.0.0.0/0"]
   }
 }
