#!/bin/bash

# CLOS BGP EVPN VXLAN Deployment Script
# This script deploys a ContainerLab topology with CLOS architecture

set -e

echo "=== CLOS BGP EVPN VXLAN Deployment ==="
echo "Starting deployment..."

# Check if ContainerLab is installed
if ! command -v containerlab &> /dev/null; then
    echo "ContainerLab is not installed. Please install it first:"
    echo "curl -sL https://get.containerlab.dev | bash"
    exit 1
fi

# Check if Docker is running
if ! docker info &> /dev/null; then
    echo "Docker is not running. Please start Docker first."
    exit 1
fi

# Create necessary directories
echo "Creating configuration directories..."
mkdir -p configs/{spine1,spine2,leaf1,leaf2,leaf3,leaf4}

# Deploy the topology
echo "Deploying ContainerLab topology..."
containerlab deploy --topo topology.yaml

echo "Waiting for nodes to be ready..."
sleep 30

# Check node status
echo "Checking node status..."
containerlab inspect --topo topology.yaml

echo "=== Deployment Complete ==="
echo ""
echo "Management IPs:"
echo "  spine1: 172.20.20.10"
echo "  spine2: 172.20.20.11"
echo "  leaf1:  172.20.20.20"
echo "  leaf2:  172.20.20.21"
echo "  leaf3:  172.20.20.22"
echo "  leaf4:  172.20.20.23"
echo "  host1:  172.20.20.30"
echo "  host2:  172.20.20.31"
echo "  host3:  172.20.20.32"
echo "  host4:  172.20.20.33"
echo ""
echo "To test connectivity:"
echo "  docker exec -it host1 ping 10.1.1.20  # host1 to host2 (same VLAN)"
echo "  docker exec -it host3 ping 10.2.2.20  # host3 to host4 (same VLAN)"
echo ""
echo "To destroy the topology:"
echo "  containerlab destroy --topo topology.yaml"
