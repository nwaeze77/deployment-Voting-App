terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}

data "aws_eks_cluster" "ClusterName" {
  name = "ClusterName"
}
data "aws_eks_cluster_auth" "ClusterName_auth" {
  name = "ClusterName_auth"
}

provider "kubernetes" {
   host                   = data.aws_eks_cluster.ClusterName.endpoint
   cluster_ca_certificate = base64decode(data.aws_eks_cluster.ClusterName.certificate_authority[0].data)
   version          = "2.16.1"
   config_path = "~/.kube/config"
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", "ClusterName"]
    command     = "aws"
  }
}

resource "kubernetes_namespace" "kube-namespace" {
  metadata {
    name = "voting-app"
  }
}