terraform {
 required_providers {
   huaweicloud = {
     source  = "huaweicloud/huaweicloud"
     version = "~> 1.26.0"
   }

 }
 backend "local" {
    path = "./terraform.tfstate"
  }
 
}
variable "access_key" {
  description = "Huawei Cloud access key"
  type        = string
  sensitive   = true
}

variable "secret_key" {
  description = "Huawei Cloud secret key"
  type        = string
  sensitive   = true
}

provider "huaweicloud" {
 cloud    = "managedcognitivecloud.com"
 auth_url = "https://iam-pub.me-east-212.managedcognitivecloud.com:443/v3/"
 insecure = "true"
 region   = "me-east-212"
 enterprise_project_id = "0"
 endpoints = {
   ecs = "https://ecs.me-east-212.managedcognitivecloud.com"
   vpc = "https://vpc.me-east-212.managedcognitivecloud.com"
 }
 access_key = var.access_key
 secret_key = var.secret_key
}


data "huaweicloud_compute_flavors" "myflavor" {
  availability_zone = "me-east-212a"
  performance_type  = "normal"
  cpu_core_count    = 2
  memory_size       = 4
}

output "matching_flavor_ids" {
  value = data.huaweicloud_compute_flavors.myflavor.ids
}

resource "huaweicloud_compute_instance" "basic" {
  name               = "test-instance-terraform"
  image_id           = "42ccabf5-f37e-42e9-833a-0927199d2340"
  flavor_id          = "p3snl.2xlarge.8"
  security_group_ids = ["c8ae9c7b-f1a1-40d7-b90d-bf7f61f5b302"]
  availability_zone  = "me-east-212a"
  system_disk_type = "SSD"  # ✅ instead of root_block_device
  system_disk_size = 40     # in GB
  network {
    uuid = "06a3d364-44b8-4a34-923c-b107511629eb"
  }
  
  user_data = <<EOF
#cloud-config
runcmd:
  - curl -k -O 'https://hss-agent.me-east-212.managedcognitivecloud.com:10180/package/agent/linux/install/agent_Install.sh'
  - echo 'MASTER_IP=hss-agent.me-east-212.managedcognitivecloud.com:10180' > hostguard_setup_config.conf
  - echo 'SLAVE_IP=hss-agent-slave.me-east-212.managedcognitivecloud.com:10180' >> hostguard_setup_config.conf
  - echo 'ORG_ID=' >> hostguard_setup_config.conf
  - chmod +x agent_Install.sh
  - bash agent_Install.sh
  - rm -f agent_Install.sh
EOF
   
}

resource "huaweicloud_vpc" "testvpc8951" {
 name = "testvpc8951"
 cidr = "192.168.0.0/16"
}
