#!/bin/bash

# Git-based deployment script
# This creates a git repository and pushes to your VPS

echo "🔧 Setting up Git-based deployment..."

# Initialize git repository
git init
git add .
git commit -m "Initial Perfex CRM deployment"

# Add VPS as remote (replace with your VPS details)
# git remote add production user@vps-ip:/path/to/git/repo.git

echo "📋 To complete Git-based deployment:"
echo "1. On VPS, create bare repository: git init --bare /path/to/repo.git"
echo "2. Add remote: git remote add production user@vps-ip:/path/to/repo.git"
echo "3. Push: git push production main"
echo "4. On VPS, clone and build: git clone /path/to/repo.git /opt/erpv3"