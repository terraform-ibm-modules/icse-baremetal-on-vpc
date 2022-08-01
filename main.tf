##############################################################################
# Create Virtual Server Deployments
##############################################################################

resource "ibm_is_bare_metal_server" "baremetal" {
  name           = "${var.prefix}-${var.name}-baremetal"
  image          = var.image_id
  profile        = var.profile
  resource_group = var.resource_group_id
  vpc            = var.vpc_id
  zone           = var.zone
  user_data      = var.user_data
  keys           = var.ssh_key_ids

  primary_network_interface {
    subnet                    = var.primary_subnet_id
    security_groups           = var.primary_security_group_ids
    allow_ip_spoofing         = var.allow_ip_spoofing
    allowed_vlans             = var.primary_allowed_vlans
    enable_infrastructure_nat = var.primary_enable_infrastructure_nat

    dynamic "primary_ip" {
      for_each = var.primary_ip.use_primary_ip == true ? [var.primary_ip] : []
      content {
        address     = lookup(primary_ip, "address", null)
        auto_delete = lookup(primary_ip, "auto_delete", null)
        name        = lookup(primary_ip, "name", null)
        reserved_ip = lookup(primary_ip, "reserved_ip", null)
      }
    }
  }
}

##############################################################################

##############################################################################
# Set boot volume name
##############################################################################

resource "ibm_is_bare_metal_server_disk" "disk" {
  bare_metal_server = ibm_is_bare_metal_server.baremetal.id
  disk              = ibm_is_bare_metal_server.baremetal.disks.0.id
  name              = var.boot_volume_name
}

##############################################################################

##############################################################################
# Optionally add secondary interfaces
##############################################################################

module "network_interface_map" {
  source = "github.com/Cloud-Schematics/list-to-map"
  list   = var.additional_network_interfaces
}

resource "ibm_is_bare_metal_server_network_interface" "network_interface" {
  for_each                  = module.network_interface_map.value
  bare_metal_server         = ibm_is_bare_metal_server.baremetal.id
  subnet                    = each.value.subnet_id
  name                      = each.value.name
  allow_ip_spoofing         = each.value.allow_ip_spoofing
  allowed_vlans             = each.value.allowed_vlans
  enable_infrastructure_nat = each.value.enable_infrastructure_nat
  hard_stop                 = each.value.hard_stop
  security_groups           = each.value.security_group_ids
  vlan                      = each.value.vlan

  dynamic "primary_ip" {
    for_each = each.value.primary_ip.use_primary_ip == true ? [each.value.primary_ip] : []
    content {
      address     = lookup(primary_ip, "address", null)
      auto_delete = lookup(primary_ip, "auto_delete", null)
      name        = lookup(primary_ip, "name", null)
      reserved_ip = lookup(primary_ip, "reserved_ip", null)
    }
  }
}

##############################################################################

##############################################################################
# Optionally Add Floating IPs
##############################################################################

resource "ibm_is_floating_ip" "baremetal_fip" {
  count  = var.add_floating_ip == true ? 1 : 0
  name   = "${var.prefix}-${var.name}-baremetal-fip"
  target = ibm_is_bare_metal_server.baremetal.primary_network_interface.0.id
}

resource "ibm_is_floating_ip" "secondary_nic_fip" {
  for_each = {
    for interface in module.network_interface_map.value :
    (interface.name) => interface if interface.add_floating_ip == true
  }
  name   = "${var.prefix}-${var.name}-baremetal-${each.value.name}-fip"
  target = ibm_is_bare_metal_server_network_interface.network_interface[each.value.name].network_interface
}

##############################################################################