############################################
# Global Variables
############################################

variable "rg_name" {
  description = "Resource Group Name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "prefix" {
  description = "Prefix for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name (dev/preprod/prod)"
  type        = string
}

variable "owner" {
  description = "Owner tag"
  type        = string
}

############################################
# AKS Variables
############################################

variable "aks_cluster_name" {
  description = "AKS cluster name"
  type        = string
}

variable "aks_node_size" {
  description = "AKS node VM size"
  type        = string
}

variable "aks_node_count" {
  description = "AKS node count"
  type        = number
}

variable "kubernetes_version" {
  description = "AKS Kubernetes version"
  type        = string
}