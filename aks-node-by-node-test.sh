# 




#!/bin/bash
# set -e

# ############################################
# # AKS Node-by-Node Upgrade (SYNTAX TEST)
# ############################################

# RESOURCE_GROUP="test-rg"
# AKS_NAME="test-aks"
# CURRENT_VERSION="1.32.9"
# TARGET_VERSION="1.33.4"

# echo "=========================================="
# echo " AKS NODE-BY-NODE UPGRADE – SYNTAX TEST"
# echo "=========================================="
# echo "Resource Group : $RESOURCE_GROUP"
# echo "AKS Name       : $AKS_NAME"
# echo "Current Version: $CURRENT_VERSION"
# echo "Target Version : $TARGET_VERSION"
# echo ""

# # Version check
# if [[ "$CURRENT_VERSION" == "$TARGET_VERSION" ]]; then
#   echo "AKS is already on the target version. No upgrade required."
#   exit 0
# else
#   echo "Upgrade required. Proceeding with node-by-node upgrade..."
# fi

# echo ""

# # Simulated node pools
# NODEPOOLS=("systempool" "userpool")

# # Simulated nodes per pool
# NODES_systempool=("sys-node-1" "sys-node-2")
# NODES_userpool=("user-node-1" "user-node-2" "user-node-3")

# for POOL in "${NODEPOOLS[@]}"; do
#   echo "------------------------------------------"
#   echo "Upgrading node pool: $POOL"
#   echo "------------------------------------------"

#   # Select nodes for the pool
#   if [[ "$POOL" == "systempool" ]]; then
#     NODES=("${NODES_systempool[@]}")
#   else
#     NODES=("${NODES_userpool[@]}")
#   fi

#   for NODE in "${NODES[@]}"; do
#     echo ""
#     echo "➡️  Processing node: $NODE"

#     echo "  - Cordoning node"
#     sleep 1

#     echo "  - Draining workloads"
#     sleep 1

#     echo "  - Creating new node with version $TARGET_VERSION"
#     sleep 1

#     echo "  - Moving workloads to new node"
#     sleep 1

#     echo "  - Deleting old node"
#     sleep 1

#     echo "  ✔ Node $NODE upgraded successfully"
#   done

#   echo ""
#   echo "✔ Node pool $POOL upgrade completed"
# done

# echo ""
# echo "=========================================="
# echo " NODE-BY-NODE UPGRADE SYNTAX PASSED ✅"
# echo "=========================================="
###########################3
#break the node and looking out issue 
#!/bin/bash
set -e

############################################
# AKS Node-by-Node Upgrade (FAILURE SIMULATION)
############################################

RESOURCE_GROUP="test-rg"
AKS_NAME="test-aks"
CURRENT_VERSION="1.32.9"
TARGET_VERSION="1.33.4"

echo "=========================================="
echo " AKS NODE-BY-NODE UPGRADE – FAILURE TEST"
echo "=========================================="
echo "AKS Name        : $AKS_NAME"
echo "Current Version : $CURRENT_VERSION"
echo "Target Version  : $TARGET_VERSION"
echo ""

if [[ "$CURRENT_VERSION" == "$TARGET_VERSION" ]]; then
  echo "AKS already on target version. Exiting."
  exit 0
fi

echo "Upgrade required. Starting node-by-node upgrade..."
echo ""

# Simulated node pools
NODEPOOLS=("systempool")

# Simulated nodes
NODES_systempool=("sys-node-1" "sys-node-2")

for POOL in "${NODEPOOLS[@]}"; do
  echo "------------------------------------------"
  echo "Upgrading node pool: $POOL"
  echo "------------------------------------------"

  NODES=("${NODES_systempool[@]}")

  for NODE in "${NODES[@]}"; do
    echo ""
    echo "➡️  Processing node: $NODE"

    echo "  - Cordoning node"
    sleep 1

    echo "  - Draining workloads"
    sleep 1

    echo "  - Creating new node with version $TARGET_VERSION"
    sleep 1

    ############################################
    # FAILURE SIMULATION
    ############################################
    if [[ "$NODE" == "sys-node-2" ]]; then
      echo ""
      echo "❌ NODE CREATION FAILED"
      echo "------------------------------------------"
      echo "Node          : $NODE"
      echo "Reason        : Insufficient CPU / Memory"
      echo ""
      echo "ACTION REQUIRED:"
      echo "  1. Check node SKU capacity"
      echo "  2. Verify Azure VM quota"
      echo "  3. Check disk pressure"
      echo "  4. Review pod resource requests"
      echo ""
      echo "Upgrade stopped to prevent outage."
      exit 1
    fi
    ############################################

    echo "  - Moving workloads to new node"
    sleep 1

    echo "  - Deleting old node"
    sleep 1

    echo "  ✔ Node $NODE upgraded successfully"
  done

  echo ""
  echo "✔ Node pool $POOL upgrade completed"
done

echo ""
echo "=========================================="
echo " NODE-BY-NODE UPGRADE COMPLETED SUCCESSFULLY"
echo "=========================================="
