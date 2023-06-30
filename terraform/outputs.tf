# # Output Color URL
# output "color_url" {
#   value = "https://${local.custom_domain_name}"
# }

# # Output AWS Region
# output "aws_region" {
#   value = local.aws_region
# }

# # Output EKS Cluster Name
# output "eks_cluster_name" {
#   value = module.eks.cluster_name
# }

# # Output ECR Repo
# output "ecr_repo_url" {
#   value = module.ecr.repository_url
# }

# Output ACM Certificate ARN 
output "flux_acm_certificate_arn" {
  value = aws_acm_certificate_validation.weave_gitops.certificate_arn
}

# # Output Color Custom Domain Name
# output "color_dns_name" {
#   value = local.custom_domain_name
# }

# Output EKS Service Account for AWS Load Balancer Controller
output "eks_sa_alb_name" {
  value = kubernetes_service_account.alb_service_account.metadata[0].name
}

# Output EKS Service Account for External DNS
output "eks_sa_external_dns_name" {
  value = kubernetes_service_account.external_dns_service_account.metadata[0].name
}

# Output Domain Filter for External DNS
output "domain_filter" {
  value = local.public_domain
}
