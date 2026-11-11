# Infra2DevOps: From Bare-Metal to Cloud-Native Platform

[![Hardware](https://img.shields.io/badge/Hardware-Dell_PowerEdge_R630-007DB8?logo=dell&logoColor=white)](https://www.dell.com/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

An end-to-end infrastructure engineering project by **[André Borsatto](https://www.linkedin.com/in/borsatto)** &bull; **[DevOpsClub.io](https://devopsclub.io)**.

---

## Milestone 01: Physical Infrastructure Topology & Hardware Architecture

- **Hardware Platform:** Dell PowerEdge R630 (2x Intel Xeon E5-2697 v4 — 36 Cores / 72 Threads, 768 GB DDR4 ECC RAM).
- **Physical Storage:** 8x Enterprise SAS SSDs in HW RAID / LVM-Thin pools (ast-lvm).
- **Network Architecture:** Dual 10GbE SFP+ uplinks + redundant 1GbE management interfaces.
- **Hypervisor:** Proxmox VE 8.x enterprise virtualization foundation.
