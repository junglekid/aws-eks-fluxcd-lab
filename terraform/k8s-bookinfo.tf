### Bookinfo App
resource "kubernetes_namespace" "bookinfo" {
  metadata {
    annotations = {
      name = "bookinfo"
    }

    labels = {
      istio-injection = "enabled"
    }

    name = "bookinfo"
  }
}

resource "tls_private_key" "bookinfo" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "bookinfo" {
  private_key_pem = tls_private_key.bookinfo.private_key_pem

  subject {
    # common_name = "bookinfo.${base_domain_name}"
    common_name = local.bookinfo_domain_name
  }

  validity_period_hours = 8760

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
    "client_auth"
  ]
}

resource "kubernetes_secret" "bookinfo_istio" {
  metadata {
    name      = "bookinfo-tls"
    namespace = kubernetes_namespace.istio_ingress.metadata[0].name
  }
  data = {
    "tls.crt" = tls_self_signed_cert.bookinfo.cert_pem
    "tls.key" = tls_private_key.bookinfo.private_key_pem
  }
  type = "kubernetes.io/tls"
}
