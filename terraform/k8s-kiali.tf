### Kiali
resource "kubernetes_namespace" "kiali" {
  metadata {
    annotations = {
      name = "kiali-operator"
    }

    labels = {
      istio-injection = "enabled"
    }

    name = "kiali-operator"
  }
}

resource "tls_private_key" "kiali" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "kiali" {
  private_key_pem = tls_private_key.kiali.private_key_pem

  subject {
    common_name = local.kiali_domain_name
  }

  validity_period_hours = 8760

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
    "client_auth"
  ]
}

resource "kubernetes_secret" "kiali_istio" {
  metadata {
    name      = "kiali-tls"
    namespace = kubernetes_namespace.istio_ingress.metadata[0].name
  }
  data = {
    "tls.crt" = tls_self_signed_cert.kiali.cert_pem
    "tls.key" = tls_private_key.kiali.private_key_pem
  }
  type = "kubernetes.io/tls"
}
