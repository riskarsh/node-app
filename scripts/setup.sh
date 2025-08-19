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

# --- Setup Application Directory ---
echo "Setting up application directory at ${APP_DIR}..."
sudo mkdir -p "${APP_DIR}"
sudo cp -r /tmp/app/* "${APP_DIR}/"

# --- Install Application Dependencies ---
echo "Installing application dependencies as root..."
cd "${APP_DIR}"

sudo npm  install

echo "Configuring PM2 to start the application on boot as the root user..."
# Generate the startup script for the 'root' user.
# The home path (--hp) for root is /root.
sudo env PATH=$PATH:/usr/bin pm2 startup systemd -u root --hp /root

# Start the app via the ecosystem file to register it with PM2
# Note: No 'sudo -u' is needed as we are running this as root.
sudo pm2 start ecosystem.config.js
# Save the current process list so it will be resurrected on reboot
sudo pm2 save
sudo pm2 startup 
echo "Provisioning script finished successfully."
