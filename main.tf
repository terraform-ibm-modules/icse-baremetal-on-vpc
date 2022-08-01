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
# Optionally Add Floating IPs
##############################################################################

resource "ibm_is_floating_ip" "vsi_fip" {
  count  = var.add_floating_ip == true ? 1 : 0
  name   = "${var.prefix}-${var.name}-baremetal-fip"
  target = ibm_is_bare_metal_server.baremetal.primary_network_interface.0.id
}

##############################################################################