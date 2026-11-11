#!/usr/bin/env bash
# ==============================================================================
# Disaster Recovery & Chaos Engineering Validation Drill
# Infra2DevOps: Automated Namespace Backup, Deletion, and Recovery with Velero
# ==============================================================================
set -euo pipefail

TARGET_NAMESPACE="bookstack"
BACKUP_NAME="backup-bookstack-chaos-$(date +%s)"
RESTORE_NAME="restore-bookstack-chaos-$(date +%s)"

echo "=== [1/4] Verifying current state of namespace: ${TARGET_NAMESPACE} ==="
kubectl get pods -n "${TARGET_NAMESPACE}"
kubectl get pvc -n "${TARGET_NAMESPACE}"

echo "=== [2/4] Creating on-demand Velero backup with Kopia deduplication ==="
velero backup create "${BACKUP_NAME}" \
  --include-namespaces "${TARGET_NAMESPACE}" \
  --wait

echo "Backup status:"
velero backup describe "${BACKUP_NAME}" --details

echo "=== [3/4] CHAOS DRILL: Deliberately deleting namespace ${TARGET_NAMESPACE} ==="
kubectl delete namespace "${TARGET_NAMESPACE}"

echo "Waiting 10 seconds to ensure namespace and underlying resources are completely purged..."
sleep 10

if kubectl get namespace "${TARGET_NAMESPACE}" 2>/dev/null; then
  echo "ERROR: Namespace still exists."
  exit 1
else
  echo "CONFIRMED: Namespace ${TARGET_NAMESPACE} and all its PVCs have been purged."
fi

echo "=== [4/4] Restoring application and persistent volumes from Velero ==="
velero restore create "${RESTORE_NAME}" \
  --from-backup "${BACKUP_NAME}" \
  --wait

echo "Restore summary:"
velero restore describe "${RESTORE_NAME}"

echo "Waiting for workloads to become ready..."
kubectl rollout status deployment/bookstack-mariadb -n "${TARGET_NAMESPACE}" --timeout=300s
kubectl rollout status deployment/bookstack -n "${TARGET_NAMESPACE}" --timeout=300s

echo "=== DISASTER RECOVERY DRILL COMPLETED SUCCESSFULLY ==="
kubectl get pods -n "${TARGET_NAMESPACE}"
kubectl get pvc -n "${TARGET_NAMESPACE}"
