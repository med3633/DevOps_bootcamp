provider "kubernetes" {
    load_config_file = "false"
    host = data.aws_eks_cluster.myapp-cluster.endpoint
    token = data.aws_eks_cluster_auth.myapp-cluster.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.myapp-cluster.certificate)
}

data "aws_eks_cluster" "myapp-cluster" {
    name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "myapp-cluster" {
   name = module.eks.cluster_id
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "13.2.1"

  cluster_name =  "myapp-eks-cluster"
  cluster_version = "1.19"

  subnets = module.myapp-vpc.private_subnets
  vpc_id = module.myapp-vpc.vpc_id

  tags = {
    endpoint ="development"
    application = "myapp"
  }
  worker_groups =[
    {
    instance_type = "t2.small"
    name = "worker-groups-1"
    asg_desired_capacity = 2
    },
    {
    instance_type = "t2.small"
    name = "worker-groups-2"
    asg_desired_capacity = 1
 
    }

] 

}