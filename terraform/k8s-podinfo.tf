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
    common_name = local.podinfo_domain_name
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
    name      = "podinfo-tls"
    namespace = kubernetes_namespace.istio_ingress.metadata[0].name
  }
  data = {
    "tls.crt" = tls_self_signed_cert.podinfo.cert_pem
    "tls.key" = tls_private_key.podinfo.private_key_pem
  }
  type = "kubernetes.io/tls"
}
