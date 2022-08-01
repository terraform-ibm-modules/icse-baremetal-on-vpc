##############################################################################
# Baremetal Outputs
##############################################################################

output "id" {
  description = "ID of Baremetal server"
  value       = ibm_is_bare_metal_server.baremetal.id
}

output "crn" {
  description = "CRN of Baremetal server"
  value       = ibm_is_bare_metal_server.baremetal.crn
}

output "primary_ip" {
  description = "Primary IP of Baremetal server"
  value       = ibm_is_bare_metal_server.baremetal.primary_network_interface[0].primary_ip
}

output "floating_ip" {
  description = "Floating IP for primary network interface"
  value       = var.add_floating_ip == true ? ibm_is_floating_ip.baremetal_fip[0].address : null
}

##############################################################################