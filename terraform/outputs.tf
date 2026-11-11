output "load_balancer_ip" {
  description = "Endereço IP do HAProxy Load Balancer (Control Plane Endpoint)"
  value       = "${var.network_prefix}.${var.lb_node.ip_suffix}"
}

output "k8s_nodes_ips" {
  description = "Mapa dos nós do cluster Kubernetes e seus endereços IP na LAN"
  value = {
    for name, node in var.k8s_nodes :
    name => {
      vmid = node.vmid
      role = node.role
      ip   = "${var.network_prefix}.${node.ip_suffix}"
    }
  }
}

output "cloudflare_tunnel_id" {
  description = "ID do Cloudflare Tunnel criado para o domínio devopsclub.io"
  value       = var.enable_cloudflare_tunnel ? cloudflare_zero_trust_tunnel_cloudflared.k8s_lab_tunnel[0].id : null
}

output "cloudflare_tunnel_token" {
  description = "Token do Cloudflare Tunnel para injetar no Deployment do cloudflared no Kubernetes"
  value       = var.enable_cloudflare_tunnel ? cloudflare_zero_trust_tunnel_cloudflared.k8s_lab_tunnel[0].tunnel_token : null
  sensitive   = true
}

output "poc_urls" {
  description = "URLs públicas das aplicações de Prova de Conceito (PoC)"
  value = [
    for sub in var.poc_subdomains : "https://${sub}.${var.cloudflare_domain}"
  ]
}

