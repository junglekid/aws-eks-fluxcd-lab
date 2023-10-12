# # Output Color URL
# output "color_url" {
#   value = "https://${local.custom_domain_name}"
# }

# Output AWS Region
output "aws_region" {
  value = local.aws_region
}

# Output EKS Cluster Name
output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

# Output ECR Repo
output "ecr_repo_url" {
  value = module.ecr.repository_url
}

# Output EKS Service Account for AWS Load Balancer Controller
output "eks_sa_alb_name" {
  value = kubernetes_service_account.alb_service_account.metadata[0].name
}

output "eks_sa_alb_iam_role_arn" {
  value = module.load_balancer_controller_irsa_role.iam_role_arn
}

# Output EKS Service Account for External DNS
output "eks_sa_external_dns_name" {
  value = kubernetes_service_account.external_dns_service_account.metadata[0].name
}

output "eks_sa_external_dns_iam_role_arn" {
  value = module.external_dns_irsa_role.iam_role_arn
}

# Output EKS Service Account for External DNS
output "eks_sa_cluster_autoscaler_name" {
  value = kubernetes_service_account.cluster_autoscaler_service_account.metadata[0].name
}

output "eks_sa_cluster_autoscaler_iam_role_arn" {
  value = module.cluster_autoscaler_irsa_role.iam_role_arn
}

output "eks_sa_ebs_csi_name" {
  value = kubernetes_service_account.ebs_csi_service_account.metadata[0].name
}

output "eks_sa_ebs_csi_iam_role_arn" {
  value = module.ebs_csi_irsa_role.iam_role_arn
}

# Output Domain Filter for External DNS
output "domain_filter" {
  value = local.public_domain
}

# Weave Gitops Outputs
output "weave_gitops_domain_name" {
  value = local.weave_gitops_domain_name
}

output "weave_gitops_acm_certificate_arn" {
  value = aws_acm_certificate_validation.weave_gitops.certificate_arn
}

# Podinfo Outputs
output "podinfo_domain_name" {
  value = local.podinfo_domain_name
}

output "podinfo_acm_certificate_arn" {
  value = aws_acm_certificate_validation.podinfo.certificate_arn
}

output "react_app_domain_name" {
  value = local.react_app_domain_name
}

output "react_app_acm_certificate_arn" {
  value = aws_acm_certificate_validation.react_app.certificate_arn
}

output "grafana_domain_name" {
  value = local.grafana_domain_name
}

output "grafana_acm_certificate_arn" {
  value = aws_acm_certificate_validation.grafana.certificate_arn
}
