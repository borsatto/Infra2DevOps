# Infra2DevOps: From Bare-Metal to Cloud-Native Platform

[![Kubernetes](https://img.shields.io/badge/Kubernetes-v1.31-326CE5?logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![Velero](https://img.shields.io/badge/Velero-Disaster_Recovery-1D63ED?logo=vmware&logoColor=white)](https://velero.io/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

An end-to-end infrastructure engineering project by **[André Borsatto](https://www.linkedin.com/in/borsatto)** &bull; **[DevOpsClub.io](https://devopsclub.io)**.

---

## Milestone 05: Automated Disaster Recovery with Velero & Chaos Engineering

- **Backup Architecture:** Velero deployed with Kopia content-addressable deduplication engine.
- **Storage Target:** S3 bucket on on-premises SeaweedFS (ast-lvm).
- **Chaos Engineering Validation:** Automated validation script (scripts/chaos-drill.sh) testing deliberate deletion of the entire ookstack namespace (including MariaDB database and PVCs) and restoring with 100% data integrity in under 60 seconds.
