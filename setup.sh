#!/usr/bin/env bash
set -e

################################################################################
# DEBIAN 13 (TRIXIE) AARCH64 FULL DEV ENVIRONMENT
################################################################################

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

print()   { echo -e "${CYAN}==> $1${NC}"; }
success() { echo -e "${GREEN}✓ $1${NC}"; }
warning() { echo -e "${YELLOW}⚠ $1${NC}"; }

check_cmd() { command -v "$1" >/dev/null 2>&1; }

# Must be root
if [[ $EUID -ne 0 ]]; then
  echo "Run as root (sudo)"
  exit 1
fi

################################################################################
# SYSTEM UPDATE & BASE TOOLS
################################################################################
print "Updating system..."
apt update
apt full-upgrade -y

print "Installing base packages..."
apt install -y \
  lsb-release \
  ca-certificates \
  curl \
  wget \
  git \
  gnupg \
  unzip \
  zip \
  nano \
  htop \
  net-tools \
  apt-transport-https

success "Base system ready"

################################################################################
# JAVA (DEBIAN 13 DEFAULT = JAVA 21)
################################################################################
print "Installing OpenJDK 21..."
apt install -y openjdk-21-jdk
success "Java installed"

################################################################################
# MAVEN
################################################################################
print "Installing Maven..."
apt install -y maven
success "Maven installed"

################################################################################
# GO (ARM64)
################################################################################
GO_VERSION="1.22.0"
GO_TARBALL="go${GO_VERSION}.linux-arm64.tar.gz"

print "Installing Go ${GO_VERSION}..."
if ! check_cmd go; then
  wget -q https://go.dev/dl/${GO_TARBALL} -O /tmp/${GO_TARBALL}
  rm -rf /usr/local/go
  tar -C /usr/local -xzf /tmp/${GO_TARBALL}
  echo 'export PATH=$PATH:/usr/local/go/bin' > /etc/profile.d/go.sh
  chmod +x /etc/profile.d/go.sh
  rm /tmp/${GO_TARBALL}
  success "Go installed"
else
  warning "Go already installed"
fi

################################################################################
# NODE.JS (NODESOURCE – NOT DEBIAN GARBAGE VERSION)
################################################################################
print "Installing Node.js 20 LTS..."
if ! check_cmd node; then
  curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
  apt install -y nodejs
  success "Node.js installed"
else
  warning "Node.js already installed"
fi

################################################################################
# DOCKER (OFFICIAL REPO)
################################################################################
print "Installing Docker..."

if ! check_cmd docker; then
  apt remove -y docker docker-engine docker.io containerd runc || true

  install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/debian/gpg \
    | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

  echo \
  "deb [arch=arm64 signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
  > /etc/apt/sources.list.d/docker.list

  apt update
  apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  usermod -aG docker "${SUDO_USER:-$USER}"
  success "Docker installed"
else
  warning "Docker already installed"
fi

################################################################################
# VERIFY
################################################################################
print "Verification:"
java -version
mvn -v | head -n 1
go version
node -v
npm -v
docker --version
docker compose version
git --version

success "Debian 13 dev environment setup COMPLETE"
echo "⚠ Log out & back in for Docker group to apply"