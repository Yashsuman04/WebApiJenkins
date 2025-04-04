terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
  }
  required_version = ">=1.0.0"
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

resource "azurerm_app_service_plan" "Web_plan" {
  name                = "webPlan01"
  location            = azurerm_resource_group.web_rg.location
  resource_group_name = azurerm_resource_group.web_rg.name


  sku {
    tier = "Basic"
    size = "B1"
  }

}
resource "azurerm_app_service" "web_app" {
  name                = "WebAppppppppp01"
  location            = azurerm_resource_group.web_rg.location
  resource_group_name = azurerm_resource_group.web_rg.name
  app_service_plan_id = azurerm_app_service_plan.Web_plan.id

  site_config {
    dotnet_framework_version = "v6.0" # Change to your preferred version
    scm_type                 = "LocalGit"
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "0"
  }

  https_only = true
}

# Resource Group
resource "azurerm_resource_group" "app_rg" {
  name     = "app-service-rg-${var.environment}"
  location = var.location
  tags     = var.tags
}

# App Service Plan
resource "azurerm_service_plan" "app_plan" {
  name                = "asp-${var.environment}-${var.app_name}"
  location            = azurerm_resource_group.app_rg.location
  resource_group_name = azurerm_resource_group.app_rg.name
  os_type             = "Windows"
  sku_name            = var.app_service_plan_sku

  tags = var.tags
}

# App Service
resource "azurerm_windows_web_app" "web_app" {
  name                = "${var.app_name}-${var.environment}"
  location            = azurerm_resource_group.app_rg.location
  resource_group_name = azurerm_resource_group.app_rg.name
  service_plan_id     = azurerm_service_plan.app_plan.id

  site_config {
    always_on = true
    application_stack {
      current_stack  = "dotnet"
      dotnet_version = "v6.0"
    }
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "0"
    "ENVIRONMENT"              = var.environment
  }

  tags = var.tags
}

# Variables
variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "myapp"
}

variable "app_service_plan_sku" {
  description = "App Service Plan SKU"
  type        = string
  default     = "B1"
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default = {
    Environment = "Development"
    Project     = "Terraform"
  }
}

# Outputs
output "app_service_name" {
  value = azurerm_windows_web_app.web_app.name
}

output "app_service_url" {
  value = "https://${azurerm_windows_web_app.web_app.default_hostname}"
}

output "resource_group_name" {
  value = azurerm_resource_group.app_rg.name
}
