##############################################################################
# IBM Cloud Provider
##############################################################################

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
  ibmcloud_timeout = 60
}

##############################################################################

##############################################################################
# Baremetal Module
##############################################################################

module "baremetal" {
  source                     = "../.."
  ibmcloud_api_key           = var.ibmcloud_api_key
  region                     = var.region
  prefix                     = "at"
  tags                       = ["acceptance", "tests"]
  resource_group_id          = "1234"
  zone                       = "eu-de-1"
  vpc_id                     = "vpc-id"
  primary_subnet_id          = "subnet-id"
  primary_security_group_ids = ["group-id"]
  name                       = "icse"
  image_id                   = "r010-68ec6c5d-c687-4dd3-8259-6f10d24ecd44"
  profile                    = "cx2-metal-96x192"
  ssh_key_ids                = ["ssh-id"]
  user_data                  = "test-user-data"
  allow_ip_spoofing          = true
  add_floating_ip            = true
  additional_network_interfaces = [
    {
      name      = "eth1"
      subnet_id = "5678"
      primary_ip = {
        use_primary_ip = false
      }
    },
    {
      name      = "eth2"
      subnet_id = "90AB"
      primary_ip = {
        use_primary_ip = true
        reserved_ip    = "127.0.0.1"
      }
      add_floating_ip = true
    }
  ]
}

##############################################################################