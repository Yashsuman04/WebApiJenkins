terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.16.0"
    }
  }
}


provider "azurerm" {
  subscription_id = "9a2083dd-e5f8-4f25-9b0b-23b06a485ddb"
  tenant_id       = "1320b4f6-35bd-4e24-8d0e-f08f366c4fd7"
  features {}
}

resource "azurerm_resource_group" "web_rg" {
  name     = "WebServiceRG"
  location = "Central India"
}

resource "azurerm_service_plan" "web_plan" {
  name                = "webPlan01"
  location            = azurerm_resource_group.web_rg.location
  resource_group_name = azurerm_resource_group.web_rg.name
  os_type             = "Windows"
  sku_name            = "B1"
}

resource "azurerm_windows_web_app" "web_app" {
  name                = "yashsumannnnnnWebApp0412"
  location            = azurerm_resource_group.web_rg.location
  resource_group_name = azurerm_resource_group.web_rg.name
  service_plan_id     = azurerm_service_plan.web_plan.id

  site_config {
    scm_type = "LocalGit"
  }

  application_stack {
    dotnet_version = "6.0"
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
  }

  https_only = true
}
