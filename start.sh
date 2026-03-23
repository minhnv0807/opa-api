#!/bin/bash

# OPA API - Quick Start Script
# https://github.com/opa-ai-labs/opa-api

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                                                           ║"
echo "║     ██████╗ ██████╗  █████╗      █████╗ ██████╗ ██╗       ║"
echo "║    ██╔═══██╗██╔══██╗██╔══██╗    ██╔══██╗██╔══██╗██║       ║"
echo "║    ██║   ██║██████╔╝███████║    ███████║██████╔╝██║       ║"
echo "║    ██║   ██║██╔═══╝ ██╔══██║    ██╔══██║██╔═══╝ ██║       ║"
echo "║    ╚██████╔╝██║     ██║  ██║    ██║  ██║██║     ██║       ║"
echo "║     ╚═════╝ ╚═╝     ╚═╝  ╚═╝    ╚═╝  ╚═╝╚═╝     ╚═╝       ║"
echo "║                                                           ║"
echo "║         Universal AI CLI Proxy Server                    ║"
echo "║         Built by OPA AI Labs • https://opa.vn            ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Check if config exists
if [ ! -f "config.yaml" ]; then
    echo -e "${YELLOW}[!] config.yaml not found. Creating from example...${NC}"
    cp config.example.yaml config.yaml
    echo -e "${GREEN}[✓] Created config.yaml${NC}"
fi

# Check if Go is installed
if ! command -v go &> /dev/null; then
    echo -e "${RED}[✗] Go is not installed. Please install Go 1.21+${NC}"
    exit 1
fi

GO_VERSION=$(go version | grep -oP 'go\d+\.\d+')
echo -e "${GREEN}[✓] Go version: $GO_VERSION${NC}"

# Build
echo -e "${BLUE}[*] Building OPA API...${NC}"
go build -o opa-api ./cmd/server/

if [ $? -eq 0 ]; then
    echo -e "${GREEN}[✓] Build successful!${NC}"
else
    echo -e "${RED}[✗] Build failed!${NC}"
    exit 1
fi

# Run
echo -e "${BLUE}[*] Starting OPA API server...${NC}"
echo -e "${YELLOW}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║  Server: http://localhost:8317                           ║"
echo "║  Press Ctrl+C to stop                                    ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

./opa-api
