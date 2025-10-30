#!/bin/bash

# ==============================
# Group 3 Static Website Deployment Script
# ==============================

# 1️⃣ Set variables (edit these)
RESOURCE_GROUP="Group3StaticSiteRG"
STORAGE_ACCOUNT="group3staticweb12345"   # must be lowercase & unique
LOCATION="eastus"
SOURCE_FOLDER="./"  # folder containing index.html

# 2️⃣ Create Resource Group
echo "Creating resource group..."
az group create \
  --name $RESOURCE_GROUP \
  --location $LOCATION

# 3️⃣ Create Storage Account
echo "Creating storage account..."
az storage account create \
  --name $STORAGE_ACCOUNT \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION \
  --sku Standard_LRS \
  --kind StorageV2

# 4️⃣ Enable Static Website Hosting
echo "Enabling static website hosting..."
az storage blob service-properties update \
  --account-name $STORAGE_ACCOUNT \
  --static-website \
  --index-document index.html \
  --error-document error.html

# 5️⃣ Get Storage Account Key
ACCOUNT_KEY=$(az storage account keys list \
  --resource-group $RESOURCE_GROUP \
  --account-name $STORAGE_ACCOUNT \
  --query "[0].value" -o tsv)

# 6️⃣ Upload Website Files
echo "Uploading website files..."
az storage blob upload-batch \
  --account-name $STORAGE_ACCOUNT \
  --account-key $ACCOUNT_KEY \
  --destination '$web' \
  --source $SOURCE_FOLDER

# 7️⃣ Get Website URL
URL="https://${STORAGE_ACCOUNT}.z13.web.core.windows.net"
echo "✅ Deployment complete!"
echo "🌍 Your site is live at: $URL"