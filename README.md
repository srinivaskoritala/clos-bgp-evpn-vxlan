# CLOS BGP EVPN VXLAN Network Topology

This project implements a CLOS (Clos) network architecture using ContainerLab with BGP EVPN and VXLAN tunnel encapsulation. The topology features a leaf-spine design with end-to-end connectivity testing.

## Architecture Overview

### Network Topology
- **2 Spine Switches**: spine1, spine2
- **4 Leaf Switches**: leaf1, leaf2, leaf3, leaf4
- **4 Host Endpoints**: host1, host2, host3, host4

### CLOS Design Principles
- **Leaf-Spine Architecture**: All leaf switches connect to all spine switches
- **East-West Traffic**: Traffic flows through spine switches for inter-leaf communication
- **Redundancy**: Multiple paths between any two leaf switches
- **Scalability**: Easy to add more leaf or spine switches

### BGP EVPN Configuration
- **BGP AS**: 65001 (all switches)
- **EVPN**: Enabled for MAC address learning and VXLAN tunnel management
- **Route Distinguishers**: Unique per leaf switch and VLAN
- **VXLAN VNIs**: 100 for VLAN 100, 200 for VLAN 200

## Network Diagram

```
                    spine1 (1.1.1.1)     spine2 (1.1.1.2)
                         |                    |
                    ----+----            ----+----
                    |       |            |       |
                 leaf1   leaf2         leaf3   leaf4
                (1.1.1.10) (1.1.1.11) (1.1.1.12) (1.1.1.13)
                    |       |            |       |
                  host1   host2        host3   host4
                 (VLAN100) (VLAN100)  (VLAN200) (VLAN200)
```

## VLAN Configuration

### VLAN 100 (host1, host2)
- **Subnet**: 10.1.1.0/24
- **VXLAN VNI**: 100
- **Route Distinguisher**: 1.1.1.10:100 (leaf1), 1.1.1.11:100 (leaf2)

### VLAN 200 (host3, host4)
- **Subnet**: 10.2.2.0/24
- **VXLAN VNI**: 200
- **Route Distinguisher**: 1.1.1.12:200 (leaf3), 1.1.1.13:200 (leaf4)

## Prerequisites

- Docker
- ContainerLab
- Linux/macOS environment

## Installation

1. **Install ContainerLab**:
   ```bash
   curl -sL https://get.containerlab.dev | bash
   ```

2. **Clone this repository**:
   ```bash
   git clone https://github.com/srinivaskoritala/clos-bgp-evpn-vxlan.git
   cd clos-bgp-evpn-vxlan
   ```

## Deployment

1. **Deploy the topology**:
   ```bash
   ./deploy.sh
   ```

2. **Test connectivity**:
   ```bash
   ./test-connectivity.sh
   ```

## Management Access

| Node | Management IP | Description |
|------|---------------|-------------|
| spine1 | 172.20.20.10 | Spine switch 1 |
| spine2 | 172.20.20.11 | Spine switch 2 |
| leaf1 | 172.20.20.20 | Leaf switch 1 (VLAN 100) |
| leaf2 | 172.20.20.21 | Leaf switch 2 (VLAN 100) |
| leaf3 | 172.20.20.22 | Leaf switch 3 (VLAN 200) |
| leaf4 | 172.20.20.23 | Leaf switch 4 (VLAN 200) |
| host1 | 172.20.20.30 | Host 1 (10.1.1.10) |
| host2 | 172.20.20.31 | Host 2 (10.1.1.20) |
| host3 | 172.20.20.32 | Host 3 (10.2.2.10) |
| host4 | 172.20.20.33 | Host 4 (10.2.2.20) |

## Testing Connectivity

### Manual Testing
```bash
# Test same VLAN connectivity
docker exec -it host1 ping 10.1.1.20  # host1 to host2
docker exec -it host3 ping 10.2.2.20  # host3 to host4

# Test cross-VLAN (should fail)
docker exec -it host1 ping 10.2.2.10  # host1 to host3
```

### Automated Testing
```bash
./test-connectivity.sh
```

## BGP EVPN Verification

### Check BGP Sessions
```bash
# On any leaf switch
docker exec -it leaf1 sr_cli -- show network-instance default protocols bgp neighbor
```

### Check EVPN Routes
```bash
# Check EVPN routes for VLAN 100
docker exec -it leaf1 sr_cli -- show network-instance vlan-100 protocols bgp-evpn bgp-instance 1

# Check EVPN routes for VLAN 200
docker exec -it leaf3 sr_cli -- show network-instance vlan-200 protocols bgp-evpn bgp-instance 1
```

### Check VXLAN Interfaces
```bash
# Check VXLAN interface status
docker exec -it leaf1 sr_cli -- show interface vxlan1
```

## Configuration Files

- `topology.yaml`: ContainerLab topology definition
- `configs/spine1/config.json`: Spine1 BGP EVPN configuration
- `configs/spine2/config.json`: Spine2 BGP EVPN configuration
- `configs/leaf1/config.json`: Leaf1 BGP EVPN configuration
- `configs/leaf2/config.json`: Leaf2 BGP EVPN configuration
- `configs/leaf3/config.json`: Leaf3 BGP EVPN configuration
- `configs/leaf4/config.json`: Leaf4 BGP EVPN configuration

## Cleanup

To destroy the topology:
```bash
containerlab destroy --topo topology.yaml
```

## Troubleshooting

### Common Issues

1. **BGP sessions not establishing**:
   - Check IP connectivity between switches
   - Verify BGP configuration
   - Check firewall rules

2. **VXLAN tunnels not working**:
   - Verify EVPN configuration
   - Check VXLAN interface status
   - Verify VLAN configuration

3. **Host connectivity issues**:
   - Check VLAN tagging
   - Verify bridge table configuration
   - Check host IP configuration

### Debug Commands

```bash
# Check container status
containerlab inspect --topo topology.yaml

# Check logs
docker logs leaf1
docker logs spine1

# Enter container shell
docker exec -it leaf1 bash
```

## Features

- ✅ CLOS leaf-spine architecture
- ✅ BGP EVPN for MAC learning
- ✅ VXLAN tunnel encapsulation
- ✅ Multi-VLAN support
- ✅ End-to-end connectivity testing
- ✅ Automated deployment scripts
- ✅ Comprehensive documentation

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Author

Srinivas Koritala
- GitHub: [@srinivaskoritala](https://github.com/srinivaskoritala)
- Email: srinivas.koritala@gmail.com
