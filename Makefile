# CLOS BGP EVPN VXLAN Makefile

.PHONY: help deploy test clean status logs

# Default target
help:
	@echo "CLOS BGP EVPN VXLAN Management"
	@echo ""
	@echo "Available targets:"
	@echo "  deploy    - Deploy the ContainerLab topology"
	@echo "  test      - Run connectivity tests"
	@echo "  status    - Show topology status"
	@echo "  logs      - Show logs from all nodes"
	@echo "  clean     - Destroy the topology"
	@echo "  help      - Show this help message"

# Deploy the topology
deploy:
	@echo "Deploying CLOS BGP EVPN VXLAN topology..."
	./deploy.sh

# Run connectivity tests
test:
	@echo "Running connectivity tests..."
	./test-connectivity.sh

# Show topology status
status:
	@echo "Topology status:"
	containerlab inspect --topo topology.yaml

# Show logs from all nodes
logs:
	@echo "Showing logs from all nodes..."
	@echo "=== Spine1 Logs ==="
	docker logs spine1 --tail 20
	@echo ""
	@echo "=== Spine2 Logs ==="
	docker logs spine2 --tail 20
	@echo ""
	@echo "=== Leaf1 Logs ==="
	docker logs leaf1 --tail 20
	@echo ""
	@echo "=== Leaf2 Logs ==="
	docker logs leaf2 --tail 20
	@echo ""
	@echo "=== Leaf3 Logs ==="
	docker logs leaf3 --tail 20
	@echo ""
	@echo "=== Leaf4 Logs ==="
	docker logs leaf4 --tail 20

# Clean up the topology
clean:
	@echo "Destroying topology..."
	containerlab destroy --topo topology.yaml
	@echo "Topology destroyed."
