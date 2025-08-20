#!/bin/bash
set -e
set -x

# --- Variables ---
APP_DIR="/home/ubuntu/node-app"

# --- System Update and Dependencies ---
echo "Updating package list..."
sudo apt-get update -y

echo "Installing build-essential for native npm packages..."
sudo apt-get install -y build-essential

# --- Install Node.js v22 LTS & npm ---
echo "Installing Node.js v22..."
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs

# --- Install PM2 Process Manager ---
echo "Installing PM2 globally..."
sudo npm install -g pm2

# --- Ensure Application Directory Exists ---
echo "Ensuring application directory exists at ${APP_DIR}..."
sudo mkdir -p "${APP_DIR}"
cd "${APP_DIR}"

# --- Install Application Dependencies ---
echo "Installing application dependencies..."
sudo npm install

echo "Configuring PM2 to start the application on boot..."
sudo env PATH=$PATH:/usr/bin pm2 startup systemd -u root --hp /root

# Start the app via the ecosystem file
sudo pm2 start ecosystem.config.js
sudo pm2 save
#sudo pm2 startup

echo "Provisioning script finished successfully."
