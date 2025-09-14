#!/bin/bash

# Connectivity Test Script for CLOS BGP EVPN VXLAN
# This script tests end-to-end connectivity across the CLOS topology

set -e

echo "=== CLOS BGP EVPN VXLAN Connectivity Test ==="
echo "Testing end-to-end connectivity..."

# Function to test ping connectivity
test_ping() {
    local source=$1
    local destination=$2
    local description=$3
    
    echo "Testing: $description"
    echo "  From: $source to $destination"
    
    if docker exec -it $source ping -c 3 $destination > /dev/null 2>&1; then
        echo "  ✓ SUCCESS: Ping successful"
    else
        echo "  ✗ FAILED: Ping failed"
    fi
    echo ""
}

# Wait for BGP sessions to establish
echo "Waiting for BGP sessions to establish..."
sleep 60

# Test same VLAN connectivity (VLAN 100)
echo "=== Testing VLAN 100 Connectivity ==="
test_ping "host1" "10.1.1.20" "host1 to host2 (same VLAN 100)"

# Test same VLAN connectivity (VLAN 200)
echo "=== Testing VLAN 200 Connectivity ==="
test_ping "host3" "10.2.2.20" "host3 to host4 (same VLAN 200)"

# Test cross-VLAN connectivity (should fail)
echo "=== Testing Cross-VLAN Connectivity (should fail) ==="
test_ping "host1" "10.2.2.10" "host1 to host3 (cross-VLAN - should fail)"

# Test BGP EVPN status
echo "=== Checking BGP EVPN Status ==="
echo "Checking BGP sessions on leaf1..."
docker exec -it leaf1 sr_cli -- show network-instance default protocols bgp neighbor

echo ""
echo "Checking EVPN routes on leaf1..."
docker exec -it leaf1 sr_cli -- show network-instance vlan-100 protocols bgp-evpn bgp-instance 1

echo ""
echo "=== Connectivity Test Complete ==="
