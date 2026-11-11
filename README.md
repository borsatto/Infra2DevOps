# Infra2DevOps: From Bare-Metal to Cloud-Native Platform

[![Kubernetes](https://img.shields.io/badge/Kubernetes-v1.31-326CE5?logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![Proxmox](https://img.shields.io/badge/Proxmox_VE-v8.x-E57000?logo=proxmox&logoColor=white)](https://www.proxmox.com/)
[![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC?logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Flatcar](https://img.shields.io/badge/Flatcar-Container_Linux-4B5563?logo=linux&logoColor=white)](https://www.flatcar.org/)
[![Harbor](https://img.shields.io/badge/Harbor-Enterprise_Registry-60B932?logo=harbor&logoColor=white)](https://goharbor.io/)
[![Velero](https://img.shields.io/badge/Velero-Disaster_Recovery-1D63ED?logo=vmware&logoColor=white)](https://velero.io/)

A complete, production-grade infrastructure project documenting the end-to-end transformation of an enterprise physical server (**Dell PowerEdge R630**) into a sovereign, highly available **Kubernetes platform** with automated disaster recovery, on-premises object storage, private container registry, and a secured software supply chain.

Created and maintained by **[André Borsatto](https://www.linkedin.com/in/borsatto)** &bull; **[DevOpsClub.io](https://devopsclub.io)**.

---

## Architecture Overview

```
+-----------------------------------------------------------------------------------+
| PHYSICAL TIER: Dell PowerEdge R630 (24 Cores / 48 Threads, 256 GB ECC, SAS)      |
| Hypervisor: Proxmox VE 8.x | Storage: fast-lvm (LVM-Thin) | Network: Dual 10GbE  |
+-----------------------------------------------------------------------------------+
                                        │
                 ┌──────────────────────┴──────────────────────┐
                 ▼                                             ▼
  [ Control Plane VMs (Flatcar) ]                [ Worker Node VMs (Flatcar) ]
  • k8s-cp01: 192.168.1.101                      • k8s-worker01: 192.168.1.111
  • k8s-cp02: 192.168.1.102                      • k8s-worker02: 192.168.1.112
  • k8s-cp03: 192.168.1.103                      • k8s-worker03: 192.168.1.113
  • HAProxy LB: 192.168.1.100 (VIP)
                 │                                             │
                 └──────────────────────┬──────────────────────┘
                                        ▼
+-----------------------------------------------------------------------------------+
| KUBERNETES v1.31 CLUSTER SERVICES                                                 |
|                                                                                   |
|  • Networking: Calico CNI + MetalLB L2 (VIP 192.168.1.200) + Ingress NGINX        |
|  • Storage: Proxmox CSI (dynamic block volumes) + SeaweedFS S3 (object storage)   |
|  • Registry: Harbor Enterprise Registry (devops/*) + Trivy vulnerability scanner  |
|  • Resilience: Velero + Kopia deduplication engine (tested with chaos engineering)|
|  • Edge: Cloudflare Zero Trust Tunnel for public endpoints (wiki, books)          |
+-----------------------------------------------------------------------------------+
```

---

## Key Pillars

### 1. Declarative Virtualization (Terraform & Proxmox)
- Complete infrastructure defined as code via Terraform using the `bpg/proxmox` provider.
- Deterministic virtual machine provisioning, resource pools, and automated snippet generation.
- Zero secrets committed to Git: all credentials injected at runtime via memory-only environment variables.

### 2. Immutable Operating Systems (Flatcar Container Linux)
- Ephemeral, immutable base OS for all Kubernetes nodes.
- Bootstrap configurations generated declaratively via **Butane** into machine-readable **Ignition** configs.
- No manual SSH mutation: nodes are treated as replaceable building blocks.

### 3. High Availability Control Plane
- Stored on 3 dedicated control plane nodes with an internal `etcd` quorum.
- Fronted by an independent load balancer running HAProxy and Keepalived (`192.168.1.100`).
- Container runtime powered by `containerd` with CRI integration.

### 4. Storage Architecture (CSI & On-Premises S3)
- **Block Storage:** Proxmox CSI driver provisioned dynamically on enterprise SAS SSD/HDD pools (`fast-lvm`).
- **Object Storage:** Self-hosted **SeaweedFS** S3 cluster providing high-throughput S3 endpoints for backup archives and container registry blobs.

### 5. Private Software Supply Chain (Harbor & Trivy)
- Local enterprise registry hosting all production application images.
- Complete independence from upstream Docker Hub rate-limits and outages.
- Automated vulnerability scanning using Trivy to detect CVEs across OS packages and compiled binaries.

### 6. Verified Disaster Recovery
- Continuous backups using **Velero** with the **Kopia** content-addressable deduplication engine.
- Validated via deliberate destruction (*Chaos Engineering*): full namespace deletions of stateful applications (relational database + persistent data) restored in under 60 seconds with 100% data integrity.

---

## Repository Structure

```text
├── terraform/                  # Infrastructure as Code
│   ├── butane/                 # Flatcar Ignition configuration templates
│   ├── cloudflare-tunnel.tf    # Zero Trust Tunnel & DNS automation
│   ├── proxmox-vms.tf          # Proxmox VM definitions (CPs & Workers)
│   ├── variables.tf            # Input variable declarations
│   ├── outputs.tf              # Target outputs and connection strings
│   └── terraform.tfvars.example# Sanitized parameter template
├── ansible/
│   └── manifests/              # Production Kubernetes manifests
│       ├── 01-dashy.yaml       # Navigation dashboard
│       ├── 02-bentopdf.yaml    # PDF tooling suite
│       ├── 03-uptime-kuma.yaml # Health monitoring & status page
│       ├── 04-harbor-values.yaml # Helm values for Harbor on SeaweedFS S3
│       ├── 05-calibre-web.yaml # Technical library management
│       └── 06-bookstack.yaml   # Documentation hub (MariaDB + App)
└── README.md
```

---

## Getting Started

### 1. Prerequisites
- **Proxmox VE 8.x** host with shared or local LVM-Thin storage.
- **Terraform >= 1.5.0** installed locally.
- **kubectl** and **helm** configured on your workstation.

### 2. Configure Terraform
Copy the sample variables file and adjust parameters to match your network:

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
```

Export required tokens into your environment:
```bash
export TF_VAR_proxmox_api_token="user@pve!tokenid=secret"
export TF_VAR_cloudflare_api_token="your-cloudflare-token"
```

Initialize and deploy:
```bash
terraform init
terraform plan
terraform apply
```

### 3. Deploy Kubernetes Workloads
Apply manifests to deploy workloads through the local Harbor registry:

```bash
kubectl apply -f ansible/manifests/
```

---

## About the Author

**André Borsatto** has worked in infrastructure, networking, and systems engineering for over 25 years. This repository represents real, field-tested configurations built to bridge physical bare-metal hardware with modern cloud-native engineering.

- **LinkedIn:** [linkedin.com/in/borsatto](https://www.linkedin.com/in/borsatto)
- **Blog & Lab Notes:** [devopsclub.io](https://devopsclub.io)

---

## Release History & Timeline

Browse the codebase as it was at each specific architectural milestone:

| Release Tag | Milestone & Topic | Highlights |
| :--- | :--- | :--- |
| [`v0.1.0-ep01`](https://github.com/borsatto/Infra2DevOps/releases/tag/v0.1.0-ep01) | **Ep 01: Physical Topology & Hardware Architecture** | Dell PowerEdge R630, dual 10GbE network, SAS storage layout, bare-metal baseline |
| [`v0.2.0-ep02`](https://github.com/borsatto/Infra2DevOps/releases/tag/v0.2.0-ep02) | **Ep 02: Declarative Proxmox VM Provisioning** | Terraform IaC with `bpg/proxmox`, deterministic VM pools, Cloudflare Tunnel automation |
| [`v0.3.0-ep03`](https://github.com/borsatto/Infra2DevOps/releases/tag/v0.3.0-ep03) | **Ep 03: Flatcar Linux & Kubernetes HA Bootstrap** | Butane/Ignition immutable OS, HAProxy/Keepalived VIP, multi-master Kubernetes v1.31 |
| [`v0.4.0-ep04`](https://github.com/borsatto/Infra2DevOps/releases/tag/v0.4.0-ep04) | **Ep 04: Storage Architecture & Core Workloads** | Proxmox CSI block storage, SeaweedFS S3 object storage, production app deployment |
| [`v0.5.0-ep05`](https://github.com/borsatto/Infra2DevOps/releases/tag/v0.5.0-ep05) | **Ep 05: Disaster Recovery & Chaos Engineering** | Velero with Kopia deduplication on S3, validated with live namespace deletion drill |
| [`v1.0.0-ep06`](https://github.com/borsatto/Infra2DevOps/releases/tag/v1.0.0-ep06) | **Ep 06: Harbor Registry & Supply Chain** | Sovereign container registry, local image mirroring, Trivy CVE scanning |
| `v1.1.0-ep07` *(In Progress)* | **Ep 07: Active Directory & Split-Horizon** | Corporate perimeter, Windows AD DNS, unified LDAP/SSO authentication |
| `v1.2.0-ep08` *(Upcoming)* | **Ep 08: GitOps with ArgoCD** | Declarative continuous delivery from Git to Kubernetes cluster |

To switch your local workspace to a specific milestone:
```bash
git checkout <release-tag>
```

---

## License

This project is licensed under the MIT License.


