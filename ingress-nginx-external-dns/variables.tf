variable "resource_group_name" {
  default = "rg-aks"
  type    = string
}

variable "resource_group_location" {
  default = "eastus"
  type    = string
}

variable "cluster_name" {
  default = "aks"
  type    = string
}

variable "ingress_namespace" {
  default = "ingress"
  type = string
}

variable "domain_name" {
  default = "transgate.ai"
  type = string
}
