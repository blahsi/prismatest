# Define Terraform provider
terraform {
  required_version = ">= 1.3"
  backend "azurerm" {
    resource_group_name  = "kopicloud-tstate-rg"
    storage_account_name = "kopicloudtfstate851"
    container_name       = "tfstate"
    key                  = "mLmuEG+fCj35v8CWieqbaQfsgIKLQIv/sHVVcIglDUogZpSkhC52p1RvzFtpRc5rRNlUEAJkeXCV+AStGqefbw=="
  }
  required_providers {
    azurerm = {
      version = "~>3.2"
      source  = "hashicorp/azurerm"
    }
  }
}
# Configure the Azure provider
provider "azurerm" { 
  features {}  
}
