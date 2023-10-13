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

### Podinfo
resource "kubernetes_namespace" "podinfo" {
  metadata {
    annotations = {
      name = "podinfo"
    }

    labels = {
      istio-injection = "enabled"
    }

    name = "podinfo"
  }
}

resource "tls_private_key" "podinfo" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "podinfo" {
  private_key_pem = tls_private_key.podinfo.private_key_pem

  subject {
    common_name  = local.podinfo_domain_name
  }

  validity_period_hours = 8760

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
    "client_auth"
  ]
}

resource "kubernetes_secret" "podinfo_istio" {
  metadata {
    name = "podinfo-tls"
    namespace = kubernetes_namespace.istio_ingress.metadata[0].name
  }
  data = {
    "tls.crt" = tls_self_signed_cert.podinfo.cert_pem
    "tls.key" = tls_private_key.podinfo.private_key_pem
  }
  type = "kubernetes.io/tls"
}

### React App
resource "kubernetes_namespace" "react_app" {
  metadata {
    annotations = {
      name = "react-app"
    }

    labels = {
      istio-injection = "enabled"
    }

    name = "react-app"
  }
}

resource "tls_private_key" "react_app" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "react_app" {
  private_key_pem = tls_private_key.react_app.private_key_pem

  subject {
    common_name  = local.react_app_domain_name
  }

  validity_period_hours = 8760

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
    "client_auth"
  ]
}

resource "kubernetes_secret" "react_app_istio" {
  metadata {
    name = "react-app-tls"
    namespace = kubernetes_namespace.istio_ingress.metadata[0].name
  }
  data = {
    "tls.crt" = tls_self_signed_cert.react_app.cert_pem
    "tls.key" = tls_private_key.react_app.private_key_pem
  }
  type = "kubernetes.io/tls"
}

### Weave GitOp
resource "kubernetes_namespace" "weave_gitops" {
  metadata {
    annotations = {
      name = "weave-gitops"
    }

    labels = {
      istio-injection = "enabled"
    }

    name = "weave-gitops"
  }
}

resource "tls_private_key" "weave_gitops" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "weave_gitops" {
  private_key_pem = tls_private_key.weave_gitops.private_key_pem

  subject {
    common_name  = local.weave_gitops_domain_name
  }

  validity_period_hours = 8760

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
    "client_auth"
  ]
}

resource "kubernetes_secret" "weave_gitops_istio" {
  metadata {
    name = "weave-gitops-tls"
    namespace = kubernetes_namespace.istio_ingress.metadata[0].name
  }
  data = {
    "tls.crt" = tls_self_signed_cert.weave_gitops.cert_pem
    "tls.key" = tls_private_key.weave_gitops.private_key_pem
  }
  type = "kubernetes.io/tls"
}

### Monitoring & Grafana
resource "kubernetes_namespace" "monitoring" {
  metadata {
    annotations = {
      name = "monitoring"
    }

    # labels = {
    #   istio-injection = "enabled"
    # }

    name = "monitoring"
  }
}

resource "tls_private_key" "grafana" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "grafana" {
  private_key_pem = tls_private_key.grafana.private_key_pem

  subject {
    common_name  = local.grafana_domain_name
  }

  validity_period_hours = 8760

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
    "client_auth"
  ]
}

resource "kubernetes_secret" "grafana_istio" {
  metadata {
    name = "grafana-tls"
    namespace = kubernetes_namespace.istio_ingress.metadata[0].name
  }
  data = {
    "tls.crt" = tls_self_signed_cert.grafana.cert_pem
    "tls.key" = tls_private_key.grafana.private_key_pem
  }
  type = "kubernetes.io/tls"
}

### Wild Card Cert
resource "tls_private_key" "common_gateway" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "common_gateway" {
  private_key_pem = tls_private_key.common_gateway.private_key_pem

  subject {
    common_name  = local.podinfo_domain_name
  }

  validity_period_hours = 8760

  # dns_names = [
  #   local.podinfo_domain_name,
  #   local.react_app_domain_name,
  #   local.weave_gitops_domain_name
  # ]

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
    "client_auth"
  ]
}

resource "kubernetes_secret" "common_gateway" {
  metadata {
    name = "common-gateway-tls"
    namespace = kubernetes_namespace.istio_ingress.metadata[0].name
  }
  data = {
    "tls.crt" = tls_self_signed_cert.common_gateway.cert_pem
    "tls.key" = tls_private_key.common_gateway.private_key_pem
  }
  type = "kubernetes.io/tls"
}

## SQS
resource "kubernetes_namespace" "sqs_app" {
  metadata {
    annotations = {
      name = "sqs-app"
    }

    name = "sqs-app"
  }
}
