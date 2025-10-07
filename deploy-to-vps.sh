#!/bin/bash

# Deployment script for Perfex CRM to VPS
# Usage: ./deploy-to-vps.sh user@vps-ip /path/on/vps

VPS_USER_HOST=$1
VPS_PATH=$2

if [ -z "$VPS_USER_HOST" ] || [ -z "$VPS_PATH" ]; then
    echo "Usage: $0 user@vps-ip /path/on/vps"
    echo "Example: $0 root@192.168.1.100 /opt/erpv3"
    exit 1
fi

echo "🚀 Starting deployment to VPS..."

# Step 1: Export custom PHP image
echo "📦 Exporting custom PHP image..."
podman save localhost/erpv3_php:latest -o erpv3_php.tar

# Step 2: Create deployment package
echo "📁 Creating deployment package..."
mkdir -p deploy-package
cp -r public deploy-package/
cp -r nginx.conf deploy-package/
cp -r php deploy-package/
cp podman-compose.yml deploy-package/
cp erpv3_php.tar deploy-package/

# Step 3: Transfer to VPS
echo "🔄 Transferring files to VPS..."
scp -r deploy-package/* $VPS_USER_HOST:$VPS_PATH/

# Step 4: Create setup script for VPS
cat > deploy-package/setup-on-vps.sh << 'EOF'
#!/bin/bash
echo "🔧 Setting up Perfex CRM on VPS..."

# Load custom PHP image
echo "📥 Loading PHP image..."
podman load -i erpv3_php.tar

# Pull other required images
echo "📥 Pulling required images..."
podman pull nginx:latest
podman pull mariadb:latest

# Start services
echo "🚀 Starting services..."
podman-compose up -d

echo "✅ Deployment complete!"
echo "🌐 Access your CRM at: http://YOUR-VPS-IP"
echo "🔑 Admin login: gasepshalom001@gmail.com / StartUpGS@00237"

# Show running containers
podman-compose ps
EOF

chmod +x deploy-package/setup-on-vps.sh

# Step 5: Transfer setup script
scp deploy-package/setup-on-vps.sh $VPS_USER_HOST:$VPS_PATH/

echo "✅ Files transferred to VPS!"
echo ""
echo "🔧 Next steps on your VPS:"
echo "1. SSH to your VPS: ssh $VPS_USER_HOST"
echo "2. Navigate to: cd $VPS_PATH"
echo "3. Run setup: ./setup-on-vps.sh"
echo ""
echo "🌐 Your CRM will be available at: http://YOUR-VPS-IP"

# Cleanup
rm -rf deploy-package erpv3_php.tar

echo "🧹 Local cleanup complete!"