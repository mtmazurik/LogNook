#!/bin/bash
# azure-deploy Bourne Again Shell Script, mtm 12-28.2018
az group create --name lognookresgroup --location westus
#
az group deployment create --resource-group lognookresgroup --template-file azure-resmgr-template.json
#
az container show --resource-group lognookresgroup --name lognookcontainergroup