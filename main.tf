locals {
  cluster_name    = "gfawcett-test"
  cluster_version = "1.13"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 6.0.0"

  cluster_name    = local.cluster_name
  cluster_version = local.cluster_version
  cluster_enabled_log_types = ["api", "controllerManager", "scheduler"]

  vpc_id  = data.aws_vpc.this.id
  subnets = data.aws_subnet_ids.private.ids

  worker_groups = [
    {
      name          = "a"
      instance_type = "t3.medium"
      ami_id        = data.aws_ami.eks_worker_1_13.id

      asg_desired_capacity = 1
      asg_max_size         = 3
      asg_min_size         = 1

      autoscaling_enabled   = true
      protect_from_scale_in = false
      kubelet_extra_args    = "--node-labels=kubernetes.io/lifecycle=normal,node/type/normal=true"
    }
//    {
//      name                 = "spot-a"
//      spot_price           = "0.35"
//      instance_type        = "t3.medium"
//      asg_max_size         = 5
//      asg_desired_capacity = 2
//      asg_min_size         = 1
//      autoscaling_enabled  = true
//      kubelet_extra_args   = "--node-labels=kubernetes.io/lifecycle=spot,node/type/spot=true"
//      suspended_processes = [
//      "AZRebalance"]
//    }
  ]

  manage_aws_auth = true
}

//resource "aws_eks_node_group" "node_group" {
//  cluster_name    = local.cluster_name
//  node_group_name = "${local.cluster_name}-node-group-1"
//  node_role_arn   = module.eks.worker_iam_role_arn
//  subnet_ids      = data.aws_subnet_ids.private.ids
//  instance_types  = ["t3.medium"]
//
//  scaling_config {
//    desired_size = 1
//    max_size     = 2
//    min_size     = 1
//  }
//}
