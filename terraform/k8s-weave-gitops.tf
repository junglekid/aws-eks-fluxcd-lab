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
    common_name = local.weave_gitops_domain_name
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
    name      = "weave-gitops-tls"
    namespace = kubernetes_namespace.istio_ingress.metadata[0].name
  }
  data = {
    "tls.crt" = tls_self_signed_cert.weave_gitops.cert_pem
    "tls.key" = tls_private_key.weave_gitops.private_key_pem
  }
  type = "kubernetes.io/tls"
}
