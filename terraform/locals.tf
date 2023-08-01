locals {
  # AWS Provider 
  aws_region  = "us-west-2"  # Update with aws region
  aws_profile = "bsisandbox" # Update with aws profile

  # Account ID
  account_id = data.aws_caller_identity.current.account_id

  # Tags
  owner       = "Dallin Rasmuson" # Update with owner name
  environment = "Sandbox"
  project     = "AWS EKS and FluxCD Lab"

  # VPC Configuration
  vpc_name = "eks-fluxcds-lab-vpc"
  vpc_cidr = "10.220.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  # ECR Configuration
  ecr_repo_names = ["eks-fluxcd-lab-red-color", "eks-fluxcd-lab-blue-color"]

  # EKS Configuration
  eks_cluster_name                          = "eks-fluxcd-lab"
  eks_cluster_version                       = "1.27"
  eks_iam_role_prefix                       = "eks-fluxcd-lab"
  eks_alb_service_account_name              = "sa-aws-load-balancer-controller"
  eks_alb_external_dns_service_account_name = "sa-external-dns"
  # eks_fluxcd_namespace                      = "fluxcd"

  # ACM and Route53 Configuration
  public_domain            = "bsisandbox.com"                  # Update with your root domain
  custom_domain_name       = "eks-fluxcd-lab.bsisandbox.com"   # Update with your custom domain name
  weave_gitops_domain_name = "eks-weave-gitops.bsisandbox.com" # Update with your custom domain name
  podinfo_domain_name      = "eks-podinfo-lab.bsisandbox.com"  # Update with your custom domain name
  route53_zone_id          = data.aws_route53_zone.public_domain.zone_id

  # # fluxcd Configuration
  # fluxcd_chart_version = "5.36.10"
  # fluxcd_helm_settings = {
  #   server = {
  #     extraArgs = ["--insecure"]
  #   }
  # }

  # # Github 
  # github_repo = "aws-eks-weave-gitops-lab"
}
