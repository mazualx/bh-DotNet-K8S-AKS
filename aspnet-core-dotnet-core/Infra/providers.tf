terraform {
  required_version = "1.5.4"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.108.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "k8s" {
  name     = "k8s_resource_group"
  location = var.resource_group_location
}