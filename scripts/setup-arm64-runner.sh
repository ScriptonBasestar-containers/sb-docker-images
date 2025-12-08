#!/bin/bash
# Script: setup-arm64-runner.sh
# Purpose: Automated setup for self-hosted ARM64 GitHub Actions runner
# Usage: ./setup-arm64-runner.sh --token YOUR_GITHUB_TOKEN --url https://github.com/org/repo
# Example: ./setup-arm64-runner.sh --token ghp_xxx --url https://github.com/myorg/myrepo

set -e

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
RUNNER_VERSION="2.311.0"
RUNNER_DIR="$HOME/actions-runner"
GITHUB_TOKEN=""
GITHUB_URL=""

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --token)
      GITHUB_TOKEN="$2"
      shift 2
      ;;
    --url)
      GITHUB_URL="$2"
      shift 2
      ;;
    --version)
      RUNNER_VERSION="$2"
      shift 2
      ;;
    --dir)
      RUNNER_DIR="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: $0 --token TOKEN --url URL [--version VERSION] [--dir DIR]"
      exit 1
      ;;
  esac
done

# Validate required parameters
if [ -z "$GITHUB_TOKEN" ] || [ -z "$GITHUB_URL" ]; then
  echo -e "${RED}Error: --token and --url are required${NC}"
  echo "Usage: $0 --token YOUR_TOKEN --url https://github.com/org/repo"
  exit 1
fi

echo -e "${GREEN}=== GitHub Actions ARM64 Runner Setup ===${NC}"
echo "Runner version: $RUNNER_VERSION"
echo "Installation directory: $RUNNER_DIR"
echo "GitHub URL: $GITHUB_URL"

# Check if running on ARM64
ARCH=$(uname -m)
if [ "$ARCH" != "aarch64" ] && [ "$ARCH" != "arm64" ]; then
  echo -e "${RED}Error: This script must run on ARM64 architecture${NC}"
  echo "Current architecture: $ARCH"
  exit 1
fi

echo -e "${GREEN}✓ Confirmed ARM64 architecture: $ARCH${NC}"

# Update system
echo -e "${YELLOW}Updating system packages...${NC}"
sudo apt update && sudo apt upgrade -y

# Install Docker if not present
if ! command -v docker &> /dev/null; then
  echo -e "${YELLOW}Installing Docker...${NC}"
  curl -fsSL https://get.docker.com -o get-docker.sh
  sudo sh get-docker.sh
  sudo usermod -aG docker $USER
  echo -e "${GREEN}✓ Docker installed${NC}"
  echo -e "${YELLOW}Note: You may need to log out and back in for docker group changes${NC}"
else
  echo -e "${GREEN}✓ Docker already installed${NC}"
fi

# Install buildx if not present
if ! docker buildx version &> /dev/null; then
  echo -e "${YELLOW}Installing Docker Buildx...${NC}"
  mkdir -p ~/.docker/cli-plugins
  curl -L https://github.com/docker/buildx/releases/download/v0.12.0/buildx-v0.12.0.linux-arm64 \
    -o ~/.docker/cli-plugins/docker-buildx
  chmod +x ~/.docker/cli-plugins/docker-buildx
  echo -e "${GREEN}✓ Docker Buildx installed${NC}"
else
  echo -e "${GREEN}✓ Docker Buildx already installed${NC}"
fi

# Verify Docker
echo -e "${YELLOW}Verifying Docker installation...${NC}"
if docker run --rm hello-world &> /dev/null; then
  echo -e "${GREEN}✓ Docker is working${NC}"
else
  echo -e "${RED}Error: Docker test failed${NC}"
  echo "Try: newgrp docker"
  exit 1
fi

# Create runner directory
echo -e "${YELLOW}Creating runner directory...${NC}"
mkdir -p "$RUNNER_DIR"
cd "$RUNNER_DIR"

# Download runner
echo -e "${YELLOW}Downloading GitHub Actions Runner v${RUNNER_VERSION}...${NC}"
RUNNER_FILE="actions-runner-linux-arm64-${RUNNER_VERSION}.tar.gz"
RUNNER_URL="https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/${RUNNER_FILE}"

if [ ! -f "$RUNNER_FILE" ]; then
  curl -o "$RUNNER_FILE" -L "$RUNNER_URL"
  echo -e "${GREEN}✓ Runner downloaded${NC}"
else
  echo -e "${GREEN}✓ Runner already downloaded${NC}"
fi

# Extract runner
echo -e "${YELLOW}Extracting runner...${NC}"
tar xzf "$RUNNER_FILE"
echo -e "${GREEN}✓ Runner extracted${NC}"

# Configure runner
echo -e "${YELLOW}Configuring runner...${NC}"
./config.sh \
  --url "$GITHUB_URL" \
  --token "$GITHUB_TOKEN" \
  --name "arm64-runner-$(hostname)" \
  --labels "self-hosted,Linux,ARM64,ubuntu-latest-arm64" \
  --work _work \
  --unattended

echo -e "${GREEN}✓ Runner configured${NC}"

# Install as service
echo -e "${YELLOW}Installing runner as systemd service...${NC}"
sudo ./svc.sh install
echo -e "${GREEN}✓ Service installed${NC}"

# Start service
echo -e "${YELLOW}Starting runner service...${NC}"
sudo ./svc.sh start
echo -e "${GREEN}✓ Service started${NC}"

# Check status
echo -e "${YELLOW}Checking service status...${NC}"
if sudo ./svc.sh status | grep -q "active (running)"; then
  echo -e "${GREEN}✓ Runner is active and running${NC}"
else
  echo -e "${RED}Warning: Runner service may not be running properly${NC}"
  sudo ./svc.sh status
fi

# Set up monitoring script
echo -e "${YELLOW}Creating monitoring script...${NC}"
cat > monitor-runner.sh << 'MONITOR_EOF'
#!/bin/bash
# GitHub Actions Runner Monitor

RUNNER_DIR="$HOME/actions-runner"
cd "$RUNNER_DIR" || exit 1

# Check runner service
if ! sudo ./svc.sh status | grep -q "active (running)"; then
  echo "[$(date)] Runner not running, restarting..."
  sudo ./svc.sh restart
  # Send notification (configure your notification method)
  # Example: curl -X POST -H 'Content-type: application/json' \
  #   --data '{"text":"Runner restarted"}' YOUR_WEBHOOK_URL
fi

# Check disk space
DISK_USAGE=$(df -h / | tail -1 | awk '{print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -gt 80 ]; then
  echo "[$(date)] WARNING: Disk usage at ${DISK_USAGE}%"
  docker system prune -af --volumes
fi

# Check memory
MEM_USAGE=$(free | grep Mem | awk '{print ($3/$2) * 100.0}' | cut -d. -f1)
if [ "$MEM_USAGE" -gt 90 ]; then
  echo "[$(date)] WARNING: Memory usage at ${MEM_USAGE}%"
fi

# Log status
echo "[$(date)] Health check completed - Disk: ${DISK_USAGE}%, Memory: ${MEM_USAGE}%"
MONITOR_EOF

chmod +x monitor-runner.sh
echo -e "${GREEN}✓ Monitoring script created${NC}"

# Set up cron job
echo -e "${YELLOW}Setting up monitoring cron job...${NC}"
(crontab -l 2>/dev/null | grep -v "monitor-runner.sh"; echo "*/5 * * * * cd $RUNNER_DIR && ./monitor-runner.sh >> monitor.log 2>&1") | crontab -
echo -e "${GREEN}✓ Cron job configured (runs every 5 minutes)${NC}"

# Configure firewall if ufw is available
if command -v ufw &> /dev/null; then
  echo -e "${YELLOW}Configuring firewall...${NC}"
  sudo ufw allow 22/tcp comment 'SSH'
  sudo ufw allow 443/tcp comment 'HTTPS for GitHub webhooks'
  sudo ufw --force enable
  echo -e "${GREEN}✓ Firewall configured${NC}"
fi

# Create uninstall script
cat > uninstall-runner.sh << 'UNINSTALL_EOF'
#!/bin/bash
# Uninstall GitHub Actions Runner

set -e

RUNNER_DIR="$HOME/actions-runner"

if [ ! -d "$RUNNER_DIR" ]; then
  echo "Runner directory not found: $RUNNER_DIR"
  exit 1
fi

cd "$RUNNER_DIR"

# Stop and uninstall service
echo "Stopping runner service..."
sudo ./svc.sh stop || true
sudo ./svc.sh uninstall || true

# Remove runner
echo "Removing runner configuration..."
./config.sh remove --token "$1" || true

# Remove cron job
echo "Removing cron job..."
crontab -l 2>/dev/null | grep -v "monitor-runner.sh" | crontab - || true

echo "Runner uninstalled successfully"
echo "To remove runner directory: rm -rf $RUNNER_DIR"
UNINSTALL_EOF

chmod +x uninstall-runner.sh
echo -e "${GREEN}✓ Uninstall script created${NC}"

# Print summary
echo ""
echo -e "${GREEN}=== Setup Complete ===${NC}"
echo ""
echo "Runner Information:"
echo "  - Name: arm64-runner-$(hostname)"
echo "  - Directory: $RUNNER_DIR"
echo "  - Labels: self-hosted, Linux, ARM64, ubuntu-latest-arm64"
echo "  - Service: actions.runner.*"
echo ""
echo "Useful Commands:"
echo "  - Check status: cd $RUNNER_DIR && sudo ./svc.sh status"
echo "  - View logs: journalctl -u actions.runner.* -f"
echo "  - Restart: cd $RUNNER_DIR && sudo ./svc.sh restart"
echo "  - Monitor: cd $RUNNER_DIR && tail -f monitor.log"
echo "  - Uninstall: cd $RUNNER_DIR && ./uninstall-runner.sh TOKEN"
echo ""
echo "Next Steps:"
echo "  1. Verify runner appears in GitHub repository settings"
echo "  2. Update workflow files to use 'ubuntu-latest-arm64' label"
echo "  3. Test a build to verify functionality"
echo "  4. Monitor runner performance and logs"
echo ""
echo -e "${GREEN}Runner is now active and ready to accept jobs!${NC}"
