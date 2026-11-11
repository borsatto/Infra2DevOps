terraform {
  required_version = ">= 1.6.0"

  # State remoto gerenciado pelo GitLab local (zero arquivo .tfstate no disco / OneDrive)
  # Inicializado via ./unlock-env.ps1 (que injeta address, lock_address e credenciais em memória)
  backend "http" {}

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.66.0"
    }
    ct = {
      source  = "poseidon/ct"
      version = "~> 0.13.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.45.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.0"
    }
  }
}

