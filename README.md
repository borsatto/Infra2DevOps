# Infra2DevOps: From Bare-Metal to Cloud-Native Platform

[![Hardware](https://img.shields.io/badge/Hardware-Dell_PowerEdge_R630-007DB8?logo=dell&logoColor=white)](https://www.dell.com/)
[![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC?logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Proxmox](https://img.shields.io/badge/Proxmox_VE-v8.x-E57000?logo=proxmox&logoColor=white)](https://www.proxmox.com/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

An end-to-end infrastructure engineering project by **[André Borsatto](https://www.linkedin.com/in/borsatto)** &bull; **[DevOpsClub.io](https://devopsclub.io)**.

---

## Milestone 02: Declarative Virtual Machine Provisioning with Terraform

- **Infrastructure as Code:** 100% declarative VM topology provisioned via pg/proxmox Terraform provider.
- **Node Allocation:** 1x HAProxy Load Balancer (k8s-lb01), 3x Control Plane nodes (k8s-cp01..03), 3x Worker nodes (k8s-worker01..03).
- **OpSec & Secrets:** Zero secrets committed to Git; credentials injected via in-memory environment variables.
