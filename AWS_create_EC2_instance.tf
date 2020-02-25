resource "aws_instance" "test-EC2" {
  ami                    = "ami-0b248d53709a335ce" #id of desired AMI
  instance_type          = "t2.small"
  subnet_id              = "subnet-0c187777047b53659"
  key_name               = "SMA-KEY"
  tags = {
    Name = "eks-worker-node"
  }
}

#Configuration des Outputs
output "public_ip" {
  value       = "${aws_instance.test-EC2.public_ip}"
  description = "The private IP address of the main server instance."
}

