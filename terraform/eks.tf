module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets
  cluster_endpoint_public_access = true

  # EKS Managed Node Groups
  eks_managed_node_groups = {
    main = {
      name = "main-node-group"
      
      instance_types = ["t3.medium"]
      
      min_size     = 2
      max_size     = 6
      desired_size = 3
      
      disk_size = 50
      
      labels = {
        role = "main"
      }
      
      tags = var.common_tags
    }
  }

  # aws-auth configmap
  manage_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn  = aws_iam_role.developer_readonly.arn
      username = "developer-readonly"
      groups   = ["readonly-group"]
    },
  ]

  tags = var.common_tags
}
