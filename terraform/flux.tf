# resource "null_resource" "fluxcd" {
#   provisioner "local-exec" {
#     command = "aws eks --region ${local.aws_region} update-kubeconfig --name ${module.eks.cluster_name} --alias ${module.eks.cluster_name}"
#   }
# }

# resource "tls_private_key" "flux" {
#   algorithm   = "ECDSA"
#   ecdsa_curve = "P256"
# }

# resource "github_repository_deploy_key" "flux" {
#   title      = "Flux"
#   repository = local.github_repo
#   key        = tls_private_key.flux.public_key_openssh
#   read_only  = "false"
# }

# resource "flux_bootstrap_git" "fluxcd" {
#   path                   = "clusters/eks-fluxcd-lab"
#   network_policy         = true
#   # kustomization_override = file("${path.module}/kustomization.yaml")
#   components_extra = ["image-automation-controller", "image-reflector-controller"]

#   depends_on = [ 
#     null_resource.fluxcd,
#     github_repository_deploy_key.flux,
#   ]
# }

# resource "helm_release" "flux" {
#   repository       = "https://fluxcd-community.github.io/helm-charts"
#   chart            = "flux2"
#   name             = "flux2"
#   namespace        = "flux-system"
#   create_namespace = true
# }
