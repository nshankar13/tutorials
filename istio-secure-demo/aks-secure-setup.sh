#!/bin/bash
set -x

PREFIX="${CLUSTER_NAME:-testCluster}"
RG="${RG:-resourceGroup}"
LOC="eastus"
PLUGIN=azure
AKSNAME="${PREFIX}"
VNET_NAME="${PREFIX}-vnet"
AKSSUBNET_NAME="${PREFIX}-subnet"
# DO NOT CHANGE FWSUBNET_NAME - This is currently a requirement for Azure Firewall.
FWSUBNET_NAME="AzureFirewallSubnet"
FWNAME="${PREFIX}-fw"
FWPUBLICIP_NAME="${PREFIX}-fwpublicip"
FWIPCONFIG_NAME="${PREFIX}-fwconfig"
FWROUTE_TABLE_NAME="${PREFIX}-fwrt"
FWROUTE_NAME="${PREFIX}-fwrn"
FWROUTE_NAME_INTERNET="${PREFIX}-fwinternet"

# az network vnet create \
#     --resource-group $RG \
#     --name $VNET_NAME \
#     --location $LOC \
#     --address-prefixes 10.42.0.0/16 \
#     --subnet-name $AKSSUBNET_NAME \
#     --subnet-prefix 10.42.1.0/24

# az network vnet subnet create \
#     --resource-group $RG \
#     --vnet-name $VNET_NAME \
#     --name $FWSUBNET_NAME \
#     --address-prefix 10.42.2.0/24

# az network public-ip create -g $RG -n $FWPUBLICIP_NAME -l $LOC --sku "Standard"

# az extension remove --name azure-firewall
# az extension add --name azure-firewall

# az network firewall create -g $RG -n $FWNAME -l $LOC --enable-dns-proxy true

# az network firewall ip-config create -g $RG -f $FWNAME -n $FWIPCONFIG_NAME --public-ip-address $FWPUBLICIP_NAME --vnet-name $VNET_NAME
FWPUBLIC_IP=$(az network public-ip show -g $RG -n $FWPUBLICIP_NAME --query "ipAddress" -o tsv)

# sleep 60
FWPRIVATE_IP=$(az network firewall show -g $RG -n $FWNAME --query "ipConfigurations[0].privateIPAddress" -o tsv)

# echo "FWPRIVATE_IP: $FWPRIVATE_IP"

# az network route-table create -g $RG -l $LOC --name $FWROUTE_TABLE_NAME
# az network route-table route create -g $RG --name $FWROUTE_NAME --route-table-name $FWROUTE_TABLE_NAME --address-prefix 0.0.0.0/0 --next-hop-type VirtualAppliance --next-hop-ip-address $FWPRIVATE_IP
# az network route-table route create -g $RG --name $FWROUTE_NAME_INTERNET --route-table-name $FWROUTE_TABLE_NAME --address-prefix $FWPUBLIC_IP/32 --next-hop-type Internet

# az network firewall network-rule create -g $RG -f $FWNAME --collection-name 'aksfwnr' -n 'apiudp' --protocols 'UDP' --source-addresses '*' --destination-addresses "AzureCloud.$LOC" --destination-ports 1194 --action allow --priority 100
# az network firewall network-rule create -g $RG -f $FWNAME --collection-name 'aksfwnr' -n 'apitcp' --protocols 'TCP' --source-addresses '*' --destination-addresses "AzureCloud.$LOC" --destination-ports 9000
# az network firewall network-rule create -g $RG -f $FWNAME --collection-name 'aksfwnr' -n 'time' --protocols 'UDP' --source-addresses '*' --destination-fqdns 'ntp.ubuntu.com' --destination-ports 123

# az network firewall application-rule create -g $RG -f $FWNAME --collection-name 'aksfwar' -n 'fqdn' --source-addresses '*' --protocols 'http=80' 'https=443' --fqdn-tags "AzureKubernetesService" --action allow --priority 100
# az network firewall application-rule create  --firewall-name $FWNAME --collection-name "dockerhub" --name "allow network" --protocols http=80 https=443 --source-addresses "*" --resource-group $RG --action "Allow" --target-fqdns "*auth.docker.io" "*cloudflare.docker.io" "*cloudflare.docker.com" "*registry-1.docker.io" --priority 200
# az network firewall application-rule create  --firewall-name $FWNAME --collection-name "quayAndGhcr" --name "allow network" --protocols http=80 https=443 --source-addresses "*" --resource-group $RG --action "Allow" --target-fqdns "*quay.io" "*ghcr.io" --priority 210
# az network firewall application-rule create  --firewall-name $FWNAME --collection-name "github" --name "allow network" --protocols http=80 https=443 --source-addresses "*" --resource-group $RG --action "Allow" --target-fqdns "*github.com" "*github.io" --priority 220
# az network firewall application-rule create  --firewall-name $FWNAME --collection-name "googleapis" --name "allow network" --protocols http=80 https=443 --source-addresses "*" --resource-group $RG --action "Allow" --target-fqdns "*storage.googleapis.com" --priority 230

# # See this for all outbound firewall rules that need to be configured for different AKS Add-Ons: https://learn.microsoft.com/en-us/azure/aks/outbound-rules-control-egress 

# # Azure Monitor Network and Application Rules
# az network firewall network-rule create -g $RG -f $FWNAME --collection-name 'azMonitorNetwork' -n 'az monitor network' --protocols 'TCP' --source-addresses '*' --destination-addresses 'AzureMonitor' --destination-ports 443 --action allow --priority 200
# az network firewall application-rule create  --firewall-name $FWNAME --collection-name "azMonitorApp" --name "az monitor app" --protocols https=443 --source-addresses "*" --resource-group $RG --action "Allow" --target-fqdns "*blob.core.windows.net" "*monitor.azure.com" "dc.services.visualstudio.com" "*.ods.opinsights.azure.com" "*.oms.opinsights.azure.com" "*.monitoring.azure.com" --priority 300

# # Azure Key Vault Application Rules
# az network firewall application-rule create  --firewall-name $FWNAME --collection-name "azKeyVault" --name "az keyvault app" --protocols https=443 --source-addresses "*" --resource-group $RG --action "Allow" --target-fqdns "vault.azure.net" --priority 310

# # Azure Policy Application Rules
# az network firewall application-rule create  --firewall-name $FWNAME --collection-name "azPolicy" --name "az policy app" --protocols https=443 --source-addresses "*" --resource-group $RG --action "Allow" --target-fqdns "data.policy.core.windows.net" "store.policy.core.windows.net" --priority 350

# az network firewall application-rule create \
# -g $RG \
# -f $FWNAME \
# --collection-name 'aksfwar2' \
# -n 'fqdn' \
# --source-addresses '*' \
# --protocols 'http=80' 'https=443' \
# --target-fqdns "mcr.microsoft.com" "*.data.mcr.microsoft.com" "management.azure.com" "login.microsoftonline.com" "packages.microsoft.com" "acs-mirror.azureedge.net" \
# --action allow --priority 101

# az network vnet subnet update -g $RG --vnet-name $VNET_NAME --name $AKSSUBNET_NAME --route-table $FWROUTE_TABLE_NAME
SUBNETID=$(az network vnet subnet show -g $RG --vnet-name $VNET_NAME --name $AKSSUBNET_NAME --query id -o tsv)
az aks create -g $RG -n $AKSNAME -l $LOC \
  --node-count 3 \
  --network-plugin azure \
  --enable-addons monitoring,azure-keyvault-secrets-provider,azure-policy \
  --network-policy azure \
  --outbound-type userDefinedRouting \
  --vnet-subnet-id $SUBNETID \
  --api-server-authorized-ip-ranges $FWPUBLIC_IP

az aks nodepool add --resource-group $RG --cluster-name $AKSNAME --name egresspool --node-taints egress=enabled:NoSchedule --labels egress=enabled --node-count 2

CURRENT_IP=$(curl ifconfig.me)
az aks update -g $RG -n $AKSNAME --api-server-authorized-ip-ranges $FWPUBLIC_IP,$CURRENT_IP/32
az aks get-credentials -g $RG -n $AKSNAME

HCP_IP=$(kubectl get endpoints -o=jsonpath='{.items[?(@.metadata.name == "kubernetes")].subsets[].addresses[].ip}')

az network firewall network-rule create --firewall-name $FWNAME --collection-name "aksnetwork" --destination-addresses "$HCP_IP"  --destination-ports 443 --name "allow network" --protocols "TCP" --resource-group $RG --source-addresses "*" --action "Allow" --description "aks master rule" --priority 120
