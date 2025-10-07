# Perfex CRM - Containerized Deployment

A fully containerized deployment of Perfex CRM using Podman/Docker with Nginx, PHP-FPM, and MariaDB.

## 🚀 Features

- **Containerized Architecture**: Nginx + PHP-FPM + MariaDB
- **Large File Support**: 500MB upload limit for modules
- **Production Ready**: Optimized for VPS deployment
- **Easy Deployment**: Automated deployment scripts included

## 📋 Prerequisites

- Podman or Docker with compose support
- 2GB+ RAM
- 10GB+ disk space

## 🛠️ Local Development Setup

### 1. Clone the Repository
```bash
git clone https://github.com/YOUR_USERNAME/perfex-crm-containerized.git
cd perfex-crm-containerized
```

### 2. Configuration
```bash
# Copy sample config and update with your settings
cp public/application/config/app-config-sample.php public/application/config/app-config.php
# Edit app-config.php with your database credentials and settings
```

### 3. Start Services
```bash
# Using Podman
podman-compose up -d --build

# Using Docker
docker-compose up -d --build
```

### 4. Access Application
- **Admin Panel**: http://localhost:8080/admin
- **Client Portal**: http://localhost:8080/

## 🏗️ Architecture

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│    Nginx    │    │ PHP-FPM 8.2 │    │  MariaDB    │
│   (Port 80) │◄──►│   Custom    │◄──►│ (Port 3306) │
│             │    │   Image     │    │             │
└─────────────┘    └─────────────┘    └─────────────┘
```

## 📦 Custom PHP Extensions

The custom PHP image includes:
- **GD**: Image processing
- **MySQLi & PDO_MySQL**: Database connectivity
- **Zip**: Archive handling
- **IMAP**: Email integration
- **Upload Configuration**: 500MB file uploads

## 🚀 VPS Deployment

### Option 1: Automated Deployment Script
```bash
# Deploy to VPS
./deploy-to-vps.sh user@your-vps-ip /opt/erpv3

# On VPS, run setup
ssh user@your-vps-ip
cd /opt/erpv3
./setup-on-vps.sh
```

### Option 2: Manual Deployment
```bash
# 1. Export custom image
podman save localhost/erpv3_php:latest -o erpv3_php.tar

# 2. Transfer files to VPS
scp -r . user@vps-ip:/opt/erpv3/

# 3. On VPS - Load image and start
podman load -i erpv3_php.tar
podman-compose -f podman-compose-production.yml up -d
```

## ⚙️ Configuration Files

| File | Purpose |
|------|---------|
| `podman-compose.yml` | Local development orchestration |
| `podman-compose-production.yml` | Production VPS orchestration |
| `php/Dockerfile` | Custom PHP image with extensions |
| `php/uploads.ini` | PHP upload configuration (500MB) |
| `nginx.conf/nginx.conf` | Nginx web server configuration |
| `deploy-to-vps.sh` | Automated VPS deployment script |

## 🔒 Security Notes

- Change default database credentials in production
- Update `app-config.php` with your domain/IP
- Remove or secure the install directory after setup
- Consider implementing SSL/TLS certificates
- Regular database backups recommended

## 📊 Default Admin Account

**Email**: gasepshalom001@gmail.com  
**Password**: StartUpGS@00237

> ⚠️ **Change these credentials immediately after first login!**

## 🐛 Troubleshooting

### Common Issues

1. **403/502 Errors**: Check file permissions and Nginx configuration
2. **Database Connection**: Verify credentials in `app-config.php`
3. **Upload Issues**: Ensure upload limits are set in both Nginx and PHP
4. **Missing Extensions**: Rebuild PHP image if extensions are missing

### Useful Commands

```bash
# Check running containers
podman-compose ps

# View logs
podman-compose logs nginx
podman-compose logs php
podman-compose logs db

# Access PHP container
podman exec -it erpv3_php_1 bash

# Database backup
podman exec erpv3_db_1 mysqldump -u root -p gasepshalomdb > backup.sql
```

## 🔄 Updates

To update the application:

1. Pull latest changes: `git pull origin main`
2. Rebuild containers: `podman-compose up -d --build`
3. Check for database migrations in admin panel

## 📝 License

This project contains Perfex CRM, which is a commercial product. Please ensure you have proper licensing for Perfex CRM before using this containerized setup.

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## 📞 Support

For deployment issues related to this containerized setup, please open an issue in this repository.

For Perfex CRM specific questions, refer to the official Perfex documentation.