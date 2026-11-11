locals {
  control_plane_ips = {
    for name, node in var.k8s_nodes :
    name => "${var.network_prefix}.${node.ip_suffix}"
    if node.role == "control-plane"
  }
}

# ============================================================================
# 1. Compilação Butane (.bu.tftpl) -> Ignition JSON (poseidon/ct)
# ============================================================================
data "ct_config" "lb_ignition" {
  content = templatefile("${path.module}/butane/haproxy.bu.tftpl", {
    hostname          = var.lb_node.name
    ip_address        = "${var.network_prefix}.${var.lb_node.ip_suffix}"
    cidr              = var.network_cidr
    gateway           = var.network_gateway
    dns               = var.network_dns
    ssh_public_key    = var.ssh_public_key
    control_plane_ips = local.control_plane_ips
  })
  strict = true
}

data "ct_config" "k8s_ignition" {
  for_each = var.k8s_nodes

  content = templatefile("${path.module}/butane/k8s-node.bu.tftpl", {
    hostname           = each.key
    ip_address         = "${var.network_prefix}.${each.value.ip_suffix}"
    cidr               = var.network_cidr
    gateway            = var.network_gateway
    dns                = var.network_dns
    ssh_public_key     = var.ssh_public_key
    k8s_sysext_version = var.k8s_sysext_version
  })
  strict = true
}

# ============================================================================
# 2. Upload dos arquivos Ignition como Snippets no Proxmox (Virtual Disk 0)
# ============================================================================
resource "proxmox_virtual_environment_file" "lb_ignition_snippet" {
  content_type = "snippets"
  datastore_id = var.snippets_datastore
  node_name    = var.proxmox_node

  source_raw {
    data      = data.ct_config.lb_ignition.rendered
    file_name = "${var.lb_node.name}.ign"
  }
}

resource "proxmox_virtual_environment_file" "k8s_ignition_snippet" {
  for_each = var.k8s_nodes

  content_type = "snippets"
  datastore_id = var.snippets_datastore
  node_name    = var.proxmox_node

  source_raw {
    data      = data.ct_config.k8s_ignition[each.key].rendered
    file_name = "${each.key}.ign"
  }
}

# ============================================================================
# 3. Provisionamento da VM Flatcar do Load Balancer (k8s-lb01)
# ============================================================================
resource "proxmox_virtual_environment_vm" "k8s_lb" {
  name            = var.lb_node.name
  description     = "Infra 2 DevOps - Flatcar Container Linux HAProxy Load Balancer"
  node_name       = var.proxmox_node
  pool_id         = var.proxmox_pool_id
  vm_id           = var.lb_node.vmid
  stop_on_destroy = true
  tags            = ["infra2devops", "flatcar", "lb"]

  clone {
    vm_id        = var.flatcar_template_vmid
    full         = true
    datastore_id = var.vm_disk_datastore
  }

  cpu {
    cores = var.lb_node.cores
    type  = "host"
  }

  memory {
    dedicated = var.lb_node.memory
  }

  disk {
    datastore_id = var.vm_disk_datastore
    interface    = "scsi0"
    size         = var.lb_node.disk_gb
    iothread     = true
    discard      = "on"
  }

  network_device {
    bridge = var.network_bridge
    model  = "virtio"
  }

  initialization {
    datastore_id      = var.vm_disk_datastore
    user_data_file_id = proxmox_virtual_environment_file.lb_ignition_snippet.id
  }

  lifecycle {
    replace_triggered_by = [
      proxmox_virtual_environment_file.lb_ignition_snippet
    ]
  }
}

# ============================================================================
# 4. Provisionamento das VMs Flatcar do Cluster K8s (3 CP + 3 Workers)
# ============================================================================
resource "proxmox_virtual_environment_vm" "k8s_nodes" {
  for_each = var.k8s_nodes

  name            = each.key
  description     = "Infra 2 DevOps - Flatcar Container Linux (${each.value.role})"
  node_name       = var.proxmox_node
  pool_id         = var.proxmox_pool_id
  vm_id           = each.value.vmid
  stop_on_destroy = true
  tags            = ["infra2devops", "flatcar", "k8s", each.value.role]

  clone {
    vm_id        = var.flatcar_template_vmid
    full         = true
    datastore_id = var.vm_disk_datastore
  }

  cpu {
    cores = each.value.cores
    type  = "host"
  }

  memory {
    dedicated = each.value.memory
  }

  disk {
    datastore_id = var.vm_disk_datastore
    interface    = "scsi0"
    size         = each.value.disk_gb
    iothread     = true
    discard      = "on"
  }

  network_device {
    bridge = var.network_bridge
    model  = "virtio"
  }

  initialization {
    datastore_id      = var.vm_disk_datastore
    user_data_file_id = proxmox_virtual_environment_file.k8s_ignition_snippet[each.key].id
  }

  lifecycle {
    replace_triggered_by = [
      proxmox_virtual_environment_file.k8s_ignition_snippet[each.key]
    ]
  }
}

