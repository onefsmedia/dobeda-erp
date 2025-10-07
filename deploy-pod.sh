#!/bin/bash

# Dobeda ERP Pod Deployment Script
# This script creates a Podman pod with all services

set -e

POD_NAME="dobeda-erp-pod"
PORT="8080"

echo "🚀 Creating Dobeda ERP Pod Deployment..."

# Step 1: Clean up any existing pod
echo "🧹 Cleaning up existing pod..."
podman pod exists $POD_NAME && podman pod rm -f $POD_NAME || true

# Step 2: Create the pod with port mapping
echo "📦 Creating pod: $POD_NAME"
podman pod create --name $POD_NAME -p $PORT:80

# Step 3: Start MariaDB in the pod
echo "🗄️  Starting MariaDB..."
podman run -d --pod $POD_NAME \
  --name ${POD_NAME}-db \
  -e MYSQL_ROOT_PASSWORD=rootpassword123 \
  -e MYSQL_DATABASE=gasepshalomdb \
  -e MYSQL_USER=gasepshalomadmin \
  -e MYSQL_PASSWORD=Nyuyforam@2024 \
  -v dobeda_pod_data:/var/lib/mysql \
  mariadb:latest

# Step 4: Wait for database to initialize
echo "⏳ Waiting for database to initialize..."
sleep 10

# Step 5: Start PHP-FPM in the pod
echo "🐘 Starting PHP-FPM..."
podman run -d --pod $POD_NAME \
  --name ${POD_NAME}-php \
  -v $(pwd)/public:/var/www/public \
  localhost/erpv3_php:latest

# Step 6: Start Nginx in the pod
echo "🌐 Starting Nginx..."
podman run -d --pod $POD_NAME \
  --name ${POD_NAME}-nginx \
  -v $(pwd)/public:/var/www/public:ro \
  -v $(pwd)/nginx-pod.conf:/etc/nginx/nginx.conf:ro \
  nginx:latest

# Step 7: Show status
echo "✅ Pod deployment complete!"
echo ""
echo "📊 Pod Status:"
podman pod ps
echo ""
echo "🐳 Container Status:"
podman ps --pod --filter pod=$POD_NAME
echo ""
echo "🌐 Access your Dobeda ERP at: http://localhost:$PORT"
echo ""
echo "🔧 Useful commands:"
echo "  podman pod logs $POD_NAME        # View all logs"
echo "  podman pod stop $POD_NAME        # Stop the pod"
echo "  podman pod start $POD_NAME       # Start the pod"
echo "  podman pod rm $POD_NAME          # Remove the pod"