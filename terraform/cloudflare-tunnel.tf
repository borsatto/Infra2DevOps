# ============================================================================
# Cloudflare Zero Trust Tunnel & DNS Records para *.devopsclub.io
# ============================================================================

resource "random_id" "tunnel_secret" {
  count       = var.enable_cloudflare_tunnel ? 1 : 0
  byte_length = 35
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "k8s_lab_tunnel" {
  count      = var.enable_cloudflare_tunnel ? 1 : 0
  account_id = var.cloudflare_account_id
  name       = "infra2devops-k8s-r630"
  secret     = random_id.tunnel_secret[0].b64_std
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "k8s_lab_tunnel_config" {
  count      = var.enable_cloudflare_tunnel ? 1 : 0
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.k8s_lab_tunnel[0].id

  config {
    dynamic "ingress_rule" {
      for_each = var.poc_subdomains
      content {
        hostname = "${ingress_rule.value}.${var.cloudflare_domain}"
        service  = var.ingress_internal_service_url
      }
    }

    # Catch-all rule exigida pela Cloudflare
    ingress_rule {
      service = "http_status:404"
    }
  }
}

resource "cloudflare_record" "poc_dns_records" {
  for_each = var.enable_cloudflare_tunnel ? toset(var.poc_subdomains) : toset([])

  zone_id = var.cloudflare_zone_id
  name    = each.value
  content = "${cloudflare_zero_trust_tunnel_cloudflared.k8s_lab_tunnel[0].id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
  comment = "Gerenciado via Terraform (Projeto Infra 2 DevOps - PoC K8s no Dell R630)"
}

