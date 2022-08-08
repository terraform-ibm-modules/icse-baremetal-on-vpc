##############################################################################
# Module Variables
##############################################################################

variable "prefix" {
  description = "The prefix that you would like to prepend to your resources"
  type        = string
}

variable "tags" {
  description = "List of Tags for the resource created"
  type        = list(string)
  default     = null
}

variable "resource_group_id" {
  description = "Resource group ID for the VSI"
  type        = string
  default     = null
}

variable "zone" {
  description = "Zone where the VSI will be provisioned"
  type        = string
}

##############################################################################

##############################################################################
# VPC Variables
##############################################################################

variable "vpc_id" {
  description = "ID of the VPC where VSI will be provisioned"
  type        = string
}

##############################################################################

##############################################################################
# Subnet Variables
##############################################################################

variable "primary_subnet_id" {
  description = "ID of the subnet where the VSI will be provisioned."
  type        = string
}

variable "primary_security_group_ids" {
  description = "(Optional) List of security group ids to add to the primary network interface. Using an empty list will assign the default VPC security group."
  type        = list(string)
  default     = []
}

variable "primary_allowed_vlans" {
  description = "Comma separated VLANs, Indicates what VLAN IDs (for VLAN type only) can use this physical (PCI type) interface. A given VLAN can only be in the allowed_vlans array for one PCI type adapter per bare metal server."
  type        = list(string)
  default     = null
}

variable "primary_enable_infrastructure_nat" {
  description = " If true, the VPC infrastructure performs any needed NAT operations. If false, the packet is passed unmodified to/from the network interface, allowing the workload to perform any needed NAT operations. [default : true]"
  type        = bool
  default     = true
}

variable "primary_ip" {
  description = "(Optional) Data describing the primary IP address for the server."
  type = object({
    use_primary_ip = bool
    address        = optional(string) # IP4 address
    auto_delete    = optional(bool)   # force delete if the reserved ip is unbound
    name           = optional(string) # IP name
    reserved_ip    = optional(string) # existing reserved IP ID, use only with `use_primary_ip`
  })
  default = {
    use_primary_ip = false
  }
}

##############################################################################

##############################################################################
# VSI Variables
##############################################################################

variable "name" {
  description = "Name of the server instance"
  type        = string
  default     = "icse"
}

variable "image_id" {
  description = "ID of the server image to use for VSI creation"
  type        = string
  default     = "r010-68ec6c5d-c687-4dd3-8259-6f10d24ecd44"
}

variable "profile" {
  description = "Type of machine profile for VSI. Use the command `ibmcloud is baremetal-profiles` to find available profiles in your region"
  type        = string
  default     = "cx2-metal-96x192"
}

variable "ssh_key_ids" {
  description = "List of SSH Key Ids. At least one SSH key must be provided"
  type        = list(string)

  validation {
    error_message = "To provision VSI at least one VPC SSH Ket must be provided."
    condition     = length(var.ssh_key_ids) > 0
  }
}

variable "boot_volume_name" {
  description = "Boot volume name"
  type        = string
  default     = "eth0"
}

##############################################################################

##############################################################################
# Common Optional Variables
##############################################################################

variable "user_data" {
  description = "(Optional) Data to transfer to instance"
  type        = string
  default     = null
}

variable "allow_ip_spoofing" {
  description = "Allow IP spoofing on primary network interface"
  type        = bool
  default     = false
}

variable "add_floating_ip" {
  description = "Add a floating IP to the primary network interface."
  type        = bool
  default     = false
}

##############################################################################

##############################################################################
# Additional Network Interfaces
##############################################################################

variable "additional_network_interfaces" {
  description = "List describing additional network interface for the baremetal"
  type = list(
    object({
      name                      = string                 # interface name
      subnet_id                 = string                 # id of the subnet where the interface is created
      allowed_vlans             = optional(list(number)) # allowed vlans
      allow_ip_spoofing         = optional(bool)         # allow ip spoofing
      enable_infrastructure_nat = optional(bool)         # If true, the VPC infrastructure performs any needed NAT operations. If false, the packet is passed unmodified to/from the network interface, allowing the workload to perform any needed NAT operations.
      hard_stop                 = optional(bool)         # Default is true. Applicable for pci type only, controls if the server should be hard stopped.
      security_group_ids        = optional(list(string)) # security group ids for secondary interface
      vlan                      = optional(number)       # Indicates the 802.1Q VLAN ID tag that must be used for all traffic on this interface
      add_floating_ip           = optional(bool)         # create floating IP for the interface
      primary_ip = object({
        use_primary_ip = bool
        address        = optional(string) # IP4 address
        auto_delete    = optional(bool)   # force delete if the reserved ip is unbound
        name           = optional(string) # IP name
        reserved_ip    = optional(string) # existing reserved IP ID, use only with `use_primary_ip`
      })
    })
  )
  default = []

  validation {
    error_message = "Each network interface must have a unique name."
    condition = (
      length(var.additional_network_interfaces) == 0
      ? true
      : length(var.additional_network_interfaces.*.name) == length(distinct(var.additional_network_interfaces.*.name))
    )
  }
}

##############################################################################