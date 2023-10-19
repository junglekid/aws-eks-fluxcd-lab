### Istio
resource "kubernetes_namespace" "istio_system" {
  metadata {
    annotations = {
      name = "istio-system"
    }

    name = "istio-system"
  }
}

resource "kubernetes_namespace" "istio_ingress" {
  metadata {
    annotations = {
      name = "istio-ingress"
    }

    labels = {
      istio-injection = "enabled"
    }

    name = "istio-ingress"
  }
}

### SQS
resource "kubernetes_namespace" "sqs_app" {
  metadata {
    annotations = {
      name = "sqs-app"
    }

    name = "sqs-app"
  }
}

resource "kubernetes_service_account" "sqs_service_account" {
  metadata {
    name      = local.eks_sqs_service_account_name
    namespace = kubernetes_namespace.sqs_app.metadata[0].name
    labels = {
      "app.kubernetes.io/name" = local.eks_sqs_service_account_name
    }
    annotations = {
      "eks.amazonaws.com/role-arn" = module.sqs_irsa_role.iam_role_arn
    }
  }

  depends_on = [
    module.eks,
    aws_eks_node_group.eks
  ]
}

### Keda
resource "kubernetes_namespace" "keda" {
  metadata {
    annotations = {
      name = "keda"
    }

    # labels = {
    #   istio-injection = "enabled"
    # }

    name = "keda"
  }
}
resource "kubernetes_storage_class" "ebs" {
  metadata {
    name = "ebs-sc"
  }

  storage_provisioner    = "kubernetes.io/aws-ebs"
  allow_volume_expansion = true
  reclaim_policy         = "Retain"
  volume_binding_mode    = "WaitForFirstConsumer"

  parameters = {
    type = "gp2"
  }
}
