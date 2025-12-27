# CLAUDE.md - Blockchain Platforms

> **Parent Context**: See `../../CLAUDE.md` for repository-wide guidelines

## Category Overview

**Purpose**: Blockchain Node & Development
**Projects**: 3 (Docker Bitcoin, Docker Ethereum, Apache Ignite)
**Focus**: Blockchain nodes, smart contracts, distributed systems

## Projects

1. **docker-bitcoin** - Bitcoin Core node (8332, 8333, 3002)
2. **docker-ethereum** - Geth + BlockScout (8545, 8546, 4000)
3. **ignite** - Apache Ignite in-memory computing

## Configuration Patterns

```bash
# Bitcoin
BITCOIN_RPC_USER=bitcoin
BITCOIN_RPC_PASSWORD=secure_pass
BITCOIN_NETWORK=testnet

# Ethereum
ETH_NETWORK=sepolia
GETH_RPC_PORT=8545
GETH_WS_PORT=8546
```

## Resource Requirements

- **Bitcoin**: High disk (500GB+ mainnet), moderate CPU
- **Ethereum**: Very high disk (1TB+ mainnet), high CPU/RAM
- **Testnet**: Recommended for development

## Security

- **RPC Access**: Restrict to trusted networks
- **Wallet Security**: Use cold storage for mainnet
- **Firewall**: Only expose necessary ports

---

**Category**: blockchain
**Last Updated**: 2025-12-28
