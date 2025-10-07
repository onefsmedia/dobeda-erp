#!/bin/bash

# GitHub-based VPS deployment script
# Usage: ./deploy-from-github.sh [git-repo-url] [vps-user@host] [vps-path]

REPO_URL=${1:-"https://github.com/onefsmedia/dobeda-erp.git"}
VPS_HOST=$2
VPS_PATH=${3:-"/opt/dobeda-erp"}

if [ -z "$VPS_HOST" ]; then
    echo "Usage: $0 [git-repo-url] vps-user@host [vps-path]"
    echo "Example: $0 https://github.com/user/repo.git root@192.168.1.100 /opt/dobeda-erp"
    exit 1
fi

echo "🚀 Deploying Dobeda ERP from GitHub to VPS..."
echo "📋 Repository: $REPO_URL"
echo "🖥️  VPS: $VPS_HOST"
echo "📁 Path: $VPS_PATH"

# Step 1: Export custom PHP image
echo "📦 Exporting custom PHP image..."
podman save localhost/erpv3_php:latest -o erpv3_php.tar

# Step 2: Transfer image to VPS
echo "🔄 Transferring PHP image to VPS..."
scp erpv3_php.tar $VPS_HOST:$VPS_PATH/

# Step 3: Create deployment script for VPS
cat > vps-setup.sh << EOF
#!/bin/bash

echo "🔧 Setting up Dobeda ERP from GitHub..."

# Clone repository
echo "📥 Cloning repository..."
git clone $REPO_URL $VPS_PATH
cd $VPS_PATH

# Load custom PHP image
echo "📥 Loading PHP image..."
podman load -i erpv3_php.tar

# Pull other required images
echo "📥 Pulling required images..."
podman pull nginx:latest
podman pull mariadb:latest

# Create app-config.php from sample
echo "📋 Setting up configuration..."
cp public/application/config/app-config-sample.php public/application/config/app-config.php

# Start services using production compose
echo "🚀 Starting services..."
podman-compose -f podman-compose-production.yml up -d

echo "✅ Deployment complete!"
echo ""
echo "🔧 Next steps:"
echo "1. Edit public/application/config/app-config.php with your database credentials"
echo "2. Update base_url to match your VPS domain/IP"
echo "3. Access your CRM at: http://YOUR-VPS-IP"
echo ""
echo "📊 Container status:"
podman-compose -f podman-compose-production.yml ps
EOF

# Step 4: Transfer and run setup script
echo "🔄 Transferring setup script to VPS..."
scp vps-setup.sh $VPS_HOST:$VPS_PATH/
ssh $VPS_HOST "chmod +x $VPS_PATH/vps-setup.sh && $VPS_PATH/vps-setup.sh"

# Cleanup
rm erpv3_php.tar vps-setup.sh

echo "✅ GitHub-based deployment complete!"
echo "🌐 Your CRM should be available at: http://YOUR-VPS-IP"