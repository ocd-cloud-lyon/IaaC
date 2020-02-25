data "aws_ami" "eks-worker-node" {
   filter {
     name   = "name"
     values = ["amazon-eks-node-${aws_eks_cluster.eks.version}-v*"]
   }

   most_recent = true
   owners      = ["573329840855"] # Amazon EKS AMI Account ID
 }

 # This data source is included for ease of sample architecture deployment
# and can be swapped out as necessary.
data "aws_region" "current" {
}

# EKS currently documents this required userdata for EKS worker nodes to
# properly configure Kubernetes applications on the EC2 instance.
# We implement a Terraform local here to simplify Base64 encoding this
# information into the AutoScaling Launch Configuration.
# More information: https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html
locals {
  eks-worker-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.eks.endpoint}' --b64-cluster-ca '${aws_eks_cluster.eks.certificate_authority[0].data}' '${var.cluster-name}'
USERDATA

}

resource "aws_launch_configuration" "eks-worker-node" {
  associate_public_ip_address = true
  iam_instance_profile        = "terraform-eks-cluster"
  image_id                    = data.aws_ami.eks-worker-node.id
  instance_type               = "m4.large"
  name_prefix                 = "terraform-eks"
  security_groups  = [aws_security_group.worker-node.id]
  user_data_base64 = base64encode(local.eks-worker-node-userdata)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "eks-worker-node" {
  desired_capacity     = 2
  launch_configuration = aws_launch_configuration.eks-worker-node.id
  max_size             = 2
  min_size             = 1
  name                 = "terraform-eks"
  #vpc_zone_identifier = [aws_subnet.demo.*.id]

  tag {
    key                 = "Name"
    value               = "terraform-eks"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster-name}"
    value               = "owned"
    propagate_at_launch = true
  }
}
