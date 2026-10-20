terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "5.10.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "backend_pipeline"
    storage_account_name = "pipelinestorageaccount13"
    container_name       = "anqit-tfstate"
    key                  = "prod.terraform.anqit-tfstate"
  }
}





provider "azurerm" {
  features {

  }
}
