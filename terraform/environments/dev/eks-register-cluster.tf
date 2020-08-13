# provider "aws" {
#   region     = "us-east-2"
#   version    = "~> 2.0"
# }

# data "aws_eks_cluster" "cluster" {
#   name = module.my-cluster.cluster_id
# }

# data "aws_eks_cluster_auth" "cluster" {
#   name = module.my-cluster.cluster_id
# }

# provider "kubernetes" {
#   host                   = data.aws_eks_cluster.cluster.endpoint
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
#   token                  = data.aws_eks_cluster_auth.cluster.token
#   load_config_file       = false
#   version                = "~> 1.9"
# }

# module "my-cluster" {
#   source          = "terraform-aws-modules/eks/aws"
#   cluster_name    = "my-cluster"
#   cluster_version = "1.16"
#   vpc_id          = "vpc-d362c1b8"
#   subnets         = ["subnet-1639f27d", "subnet-3540404f", "subnet-e17d15ad"]
#   worker_groups = [
#     {
#       instance_type = "t2.small"
#       asg_max_size  = 2
#     }
#   ]
# }

# resource "null_resource" "register" {

#   provisioner "local-exec" {
#     interpreter = ["bash", "-exc"]
#     command     = <<EOT
#     gcloud container hub memberships register "${module.my-cluster.cluster_id}" \
#     --project="${var.project_id}" \
#     --context="eks_${module.my-cluster.cluster_id}" \
#     --kubeconfig="./kubeconfig_my-cluster" \
#     --service-account-key-file="/home/rajesh_debian/first-service-account.json"
#     EOT
#   }

# }

