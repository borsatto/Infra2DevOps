# Infra2DevOps: From Bare-Metal to Cloud-Native Platform

[![Hardware](https://img.shields.io/badge/Hardware-Dell_PowerEdge_R630-007DB8?logo=dell&logoColor=white)](https://www.dell.com/)
[![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC?logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Proxmox](https://img.shields.io/badge/Proxmox_VE-v8.x-E57000?logo=proxmox&logoColor=white)](https://www.proxmox.com/)
[![Flatcar](https://img.shields.io/badge/Flatcar-Container_Linux-4B5563?logo=linux&logoColor=white)](https://www.flatcar.org/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-v1.31-326CE5?logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![Ansible](https://img.shields.io/badge/Ansible-Automation-EE0000?logo=ansible&logoColor=white)](https://www.ansible.com/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

An end-to-end infrastructure engineering project by **[André Borsatto](https://www.linkedin.com/in/borsatto)** &bull; **[DevOpsClub.io](https://devopsclub.io)**.

---

## Milestone 03: Flatcar Linux Ignition Bootstrap & Multi-Master Kubernetes Cluster

- **Immutable OS:** Flatcar Container Linux bootstrapped declaratively via Butane to Ignition templates.
- **High Availability Control Plane:** 3x Control Planes with stacked tcd behind HAProxy VIP (192.168.1.100:6443).
- **Cluster Networking:** Project Calico CNI + MetalLB L2 (192.168.1.200-220) + Ingress NGINX.
- **Ansible Automation:** End-to-end automated orchestration with nsible/playbooks/01-bootstrap-k8s.yml.
