# Infra2DevOps: From Bare-Metal to Cloud-Native Platform

[![Kubernetes](https://img.shields.io/badge/Kubernetes-v1.31-326CE5?logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![Proxmox](https://img.shields.io/badge/Proxmox_VE-v8.x-E57000?logo=proxmox&logoColor=white)](https://www.proxmox.com/)
[![Ansible](https://img.shields.io/badge/Ansible-Automation-EE0000?logo=ansible&logoColor=white)](https://www.ansible.com/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

An end-to-end infrastructure engineering project by **[André Borsatto](https://www.linkedin.com/in/borsatto)** &bull; **[DevOpsClub.io](https://devopsclub.io)**.

---

## Milestone 04: Storage Architecture (CSI & S3) & Core Workloads Deployment

- **Dynamic Block Storage:** Proxmox CSI Plugin allocating persistent volumes directly on host LVM-Thin storage (proxmox-fast).
- **Object Storage:** On-premises SeaweedFS S3 storage cluster with 200Gi capacity.
- **Core Workloads:** Dashy, BentoPDF with HPA, Uptime Kuma, Calibre-Web, and BookStack with MariaDB.
- **Workload Automation:** Declarative provisioning and automated seeding via nsible/playbooks/02-deploy-workloads.yml.
