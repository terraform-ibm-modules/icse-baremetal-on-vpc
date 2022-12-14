// This file was generated by tfxjs
const tfxjs = require("tfxjs");
const tfx = new tfxjs(
  "module_test",
  {},
  {quiet: true}
);

tfx.plan("tfx Generated Plan", () => {
  
  tfx.module(
    "Baremetal",
    'module.baremetal',
    tfx.resource(
      "Baremetal",
      'ibm_is_bare_metal_server.baremetal',
      {
        "delete_type": "hard",
        "image": "r010-68ec6c5d-c687-4dd3-8259-6f10d24ecd44",
        "keys": [
          "ssh-id"
        ],
        "name": "at-icse-baremetal",
        "primary_network_interface": [
          {
            "allow_ip_spoofing": true,
            "allowed_vlans": null,
            "enable_infrastructure_nat": true,
            "security_groups": [
              "group-id"
            ],
            "subnet": "subnet-id"
          }
        ],
        "profile": "cx2-metal-96x192",
        "resource_group": "1234",
        "user_data": "test-user-data",
        "vpc": "vpc-id",
        "zone": "eu-de-1"
      }
    ),
    tfx.resource(
      "Vsi Fip 0",
      'ibm_is_floating_ip.baremetal_fip[0]',
      {
        "name": "at-icse-baremetal-fip"
      }
    ),
    tfx.resource(
      "Baremetal disk name",
      "ibm_is_bare_metal_server_disk.disk",
      {
        "name" : "eth0"
      }
    ),
  );
});
