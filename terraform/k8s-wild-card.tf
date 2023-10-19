### Wild Card Cert
resource "tls_private_key" "common_gateway" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "common_gateway" {
  private_key_pem = tls_private_key.common_gateway.private_key_pem

  subject {
    common_name = local.podinfo_domain_name
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
    name      = "common-gateway-tls"
    namespace = kubernetes_namespace.istio_ingress.metadata[0].name
  }
  data = {
    "tls.crt" = tls_self_signed_cert.common_gateway.cert_pem
    "tls.key" = tls_private_key.common_gateway.private_key_pem
  }
  type = "kubernetes.io/tls"
}
