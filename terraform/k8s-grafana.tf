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
    common_name = local.grafana_domain_name
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
    name      = "grafana-tls"
    namespace = kubernetes_namespace.istio_ingress.metadata[0].name
  }
  data = {
    "tls.crt" = tls_self_signed_cert.grafana.cert_pem
    "tls.key" = tls_private_key.grafana.private_key_pem
  }
  type = "kubernetes.io/tls"
}
