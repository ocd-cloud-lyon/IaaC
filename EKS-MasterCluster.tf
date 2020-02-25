resource "aws_eks_cluster" "eks" {
  name            = "${var.cluster-name}"
  role_arn        = "${aws_iam_role.master-node.arn}"

  vpc_config {
    security_group_ids = ["sg-08f14b983890ad155"]
    subnet_ids         = ["subnet-0c187777047b53659",
                          "subnet-074eabb40ef5b6128"]
  }

  depends_on = [
    "aws_iam_role_policy_attachment.eks-cluster-AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.eks-cluster-AmazonEKSServicePolicy",
  ]
}
