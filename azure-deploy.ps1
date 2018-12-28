# AzureDeploy
# for LogNook example, created: mtm 12/28/2018
#
# resource group
New-AzureRmResourceGroup -Name LogNookResGrp -Location WestUS
#
New-AzureRmContainerGroup -ResourceGroupName LogNookResGrp -TemplateFile azure-resmgr-template.json
#
Get-AzureRmContainerGroup -ResourceGroupName LogNookResGrp -Name LogNookContainerGroup