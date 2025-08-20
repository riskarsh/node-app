#!/bin/bash
set -e
set -x

# --- Variables ---
APP_DIR="/home/ubuntu/node-app"
TMP_DIR="/tmp/app"

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

# --- Setup Application Directory ---
echo "Setting up application directory at ${APP_DIR}..."
sudo mkdir -p "${APP_DIR}"

# Copy uploaded files from /tmp/app to app directory
sudo cp -r "${TMP_DIR}/." "${APP_DIR}/"

# Ensure ownership is root:root (since we’re running as sudo everywhere)
sudo chown -R root:root "${APP_DIR}"

# --- Install Application Dependencies ---
echo "Installing application dependencies..."
cd "${APP_DIR}"
sudo npm install --legacy-peer-deps

# --- Configure PM2 as root ---
echo "Configuring PM2 to start the application on boot (as root)..."
sudo env PATH=$PATH:/usr/bin pm2 startup systemd -u root --hp /root

# Start the app via ecosystem file
sudo pm2 start ecosystem.config.js || echo "⚠️ ecosystem.config.js not found, skipping app start"

sudo pm2 save

echo "Provisioning script finished successfully."
