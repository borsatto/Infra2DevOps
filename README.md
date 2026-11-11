# Infra2DevOps: From Bare-Metal to Cloud-Native Platform

[![Kubernetes](https://img.shields.io/badge/Kubernetes-v1.31-326CE5?logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![Harbor](https://img.shields.io/badge/Harbor-Enterprise_Registry-60B932?logo=harbor&logoColor=white)](https://goharbor.io/)
[![Velero](https://img.shields.io/badge/Velero-Disaster_Recovery-1D63ED?logo=vmware&logoColor=white)](https://velero.io/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

An end-to-end infrastructure engineering project by **[André Borsatto](https://www.linkedin.com/in/borsatto)** &bull; **[DevOpsClub.io](https://devopsclub.io)**.

---

## Milestone 06: Sovereign Enterprise Registry with Harbor & DevSecOps Supply Chain

- **Private Registry:** Sovereign Harbor registry hosting all production application images at harbor.devopsclub.io/devops/*.
- **Closed Supply Chain:** All Kubernetes manifests repointed to local Harbor images, eliminating external Docker Hub dependencies.
- **Vulnerability Scanning:** Automated Trivy CVE scanner integrated directly into Harbor for static image analysis.
