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

#test

resource "huaweicloud_vpc" "testvpc9756" {
 name = "testvpc977"
 cidr = "192.168.0.0/16"
}


