# Create AWS ECR 
module "ecr" {
  for_each = toset(local.ecr_repo_names)

  source  = "terraform-aws-modules/ecr/aws"
  version = "~> 1.6.0"

  repository_name = each.value

  create_lifecycle_policy         = true
  repository_image_tag_mutability = "MUTABLE"
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 5 untagged images",
        selection = {
          tagStatus   = "untagged",
          countType   = "imageCountMoreThan",
          countNumber = 4
        },
        action = {
          type = "expire"
        }
      },
    ]
  })

  repository_force_delete = true

  depends_on = [module.vpc]
}
