# ============================================================================
# Proxmox VE (Dell PowerEdge R630)
# ============================================================================
variable "proxmox_endpoint" {
  description = "URL da API do Proxmox VE no Dell R630 (ex: https://192.168.1.180:8006/)"
  type        = string
}

variable "proxmox_api_token" {
  description = "Token da API do Proxmox no formato user@realm!token_id=secret"
  type        = string
  sensitive   = true
}

variable "proxmox_node" {
  description = "Nome do nó Proxmox VE"
  type        = string
  default     = "pve"
}

variable "proxmox_pool_id" {
  description = "ID da Pool de recursos do Proxmox para isolar as VMs do lab"
  type        = string
  default     = "k8s-lab"
}

variable "proxmox_ssh_user" {
  description = "Usuário SSH do host Proxmox (necessário no bpg/proxmox para upload de snippets Ignition)"
  type        = string
  default     = "root"
}

variable "snippets_datastore" {
  description = "Datastore do Proxmox com suporte a Snippets habilitado (Virtual Disk 0 - RAID-1)"
  type        = string
  default     = "local"
}

variable "vm_disk_datastore" {
  description = "Datastore de alta performance para os discos das VMs Flatcar (Virtual Disk 2 - 3.58 TB SSD SAS)"
  type        = string
  default     = "fast-lvm"
}

variable "flatcar_template_vmid" {
  description = "VMID do template base do Flatcar Container Linux no Proxmox"
  type        = number
  default     = 9000
}

# ============================================================================
# Rede & Acesso SSH (LAN HomeLab 192.168.1.0/24)
# ============================================================================
variable "network_bridge" {
  description = "Bridge de rede do Proxmox"
  type        = string
  default     = "vmbr0"
}

variable "network_prefix" {
  description = "Prefixo dos 3 primeiros octetos da LAN"
  type        = string
  default     = "192.168.1"
}

variable "network_cidr" {
  description = "Máscara CIDR da sub-rede LAN"
  type        = number
  default     = 24
}

variable "network_gateway" {
  description = "Gateway padrão da LAN"
  type        = string
  default     = "192.168.1.1"
}

variable "network_dns" {
  description = "Servidor DNS primário (Pi-hole do HomeLab em 192.168.1.4)"
  type        = string
  default     = "192.168.1.4"
}

variable "ssh_public_key" {
  description = "Chave pública SSH a ser injetada no usuário 'core' do Flatcar via Ignition"
  type        = string
}

# ============================================================================
# Versão da Extensão Kubernetes (Flatcar systemd-sysext)
# ============================================================================
variable "k8s_sysext_version" {
  description = "Versão da extensão oficial kubernetes systemd-sysext do Flatcar (extensions.flatcar.org)"
  type        = string
  default     = "v1.31.13"
}

# ============================================================================
# Topologia dos Nós Flatcar Container Linux
# ============================================================================
variable "lb_node" {
  description = "Especificação da VM Flatcar do Load Balancer (HAProxy)"
  type = object({
    name      = string
    vmid      = number
    ip_suffix = number
    cores     = number
    memory    = number
    disk_gb   = number
  })
  default = {
    name      = "k8s-lb01"
    vmid      = 100
    ip_suffix = 100
    cores     = 2
    memory    = 4096
    disk_gb   = 20
  }
}

variable "k8s_nodes" {
  description = "Mapa dos nós de Control Plane e Workers do Kubernetes rodando Flatcar Container Linux"
  type = map(object({
    vmid      = number
    ip_suffix = number
    role      = string
    cores     = number
    memory    = number
    disk_gb   = number
  }))
  default = {
    "k8s-cp01" = { vmid = 101, ip_suffix = 101, role = "control-plane", cores = 4, memory = 8192, disk_gb = 40 }
    "k8s-cp02" = { vmid = 102, ip_suffix = 102, role = "control-plane", cores = 4, memory = 8192, disk_gb = 40 }
    "k8s-cp03" = { vmid = 103, ip_suffix = 103, role = "control-plane", cores = 4, memory = 8192, disk_gb = 40 }
    "k8s-worker01" = { vmid = 111, ip_suffix = 111, role = "worker", cores = 4, memory = 16384, disk_gb = 80 }
    "k8s-worker02" = { vmid = 112, ip_suffix = 112, role = "worker", cores = 4, memory = 16384, disk_gb = 80 }
    "k8s-worker03" = { vmid = 113, ip_suffix = 113, role = "worker", cores = 4, memory = 16384, disk_gb = 80 }
  }
}

# ============================================================================
# Cloudflare Tunnel & DNS (devopsclub.io)
# ============================================================================
variable "enable_cloudflare_tunnel" {
  description = "Habilita a criação automática do Cloudflare Tunnel e registros DNS para devopsclub.io"
  type        = bool
  default     = true
}

variable "cloudflare_api_token" {
  description = "API Token da Cloudflare com permissões de Cloudflare Tunnel:Edit e DNS:Edit na zona devopsclub.io"
  type        = string
  sensitive   = true
  default     = ""
}

variable "cloudflare_account_id" {
  description = "Account ID da conta Cloudflare"
  type        = string
  default     = ""
}

variable "cloudflare_zone_id" {
  description = "Zone ID do domínio devopsclub.io na Cloudflare"
  type        = string
  default     = ""
}

variable "cloudflare_domain" {
  description = "Domínio dedicado às PoCs do cluster Kubernetes"
  type        = string
  default     = "devopsclub.io"
}

variable "poc_subdomains" {
  description = "Subdomínios das aplicações de Prova de Conceito (PoC) roteados via Cloudflare Tunnel para o Ingress Controller"
  type        = list(string)
  default = [
    "harbor",     # Harbor (Enterprise Container Registry & Security Scanner)
    "books",      # Calibre-Web
    "dash",       # Dashy
    "status",     # Uptime Kuma
    "pdf",        # Stirling-PDF / BentoPDF
    "wiki",       # BookStack
    "monitoring"  # Grafana / Prometheus
  ]
}

variable "ingress_internal_service_url" {
  description = "URL interna do Ingress Controller no cluster K8s para onde o cloudflared encaminhará o tráfego"
  type        = string
  default     = "http://ingress-nginx-controller.ingress-nginx.svc.cluster.local:80"
}

