#!/usr/bin/env bash
# One-shot deploy script for systemd+gunicorn on an Ubuntu server
# Usage (local): ssh -J misrapas@shell.metropolia.fi misrapas@<server-ip> 'bash -s' < deploy/deploy_server.sh

set -euo pipefail

REPO_URL="https://github.com/Misra-123456/flask_api_assgnment.git"
APP_DIR="/opt/flask_api"
SERVICE_FILE="/etc/systemd/system/flask_api.service"
NGINX_SITE="/etc/nginx/sites-available/flask_api"

# Clone or pull
if [ -d "$APP_DIR" ]; then
  echo "Updating existing repo..."
  cd "$APP_DIR"
  git pull origin main
else
  sudo git clone "$REPO_URL" "$APP_DIR"
  sudo chown -R $(whoami):$(whoami) "$APP_DIR"
  cd "$APP_DIR"
fi

# Setup venv
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

# create systemd service
sudo tee "$SERVICE_FILE" > /dev/null <<'EOF'
[Unit]
Description=Gunicorn instance to serve Flask API
After=network.target

[Service]
User=misrapas
Group=www-data
WorkingDirectory=/opt/flask_api
Environment="PATH=/opt/flask_api/.venv/bin"
ExecStart=/opt/flask_api/.venv/bin/gunicorn --workers 3 --bind 127.0.0.1:3000 app:app

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable flask_api
sudo systemctl restart flask_api

# nginx config
sudo tee "$NGINX_SITE" > /dev/null <<'EOF'
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /public/ {
        alias /opt/flask_api/public/;
        access_log off;
    }
}
EOF

sudo ln -sf "$NGINX_SITE" /etc/nginx/sites-enabled/flask_api
sudo nginx -t
sudo systemctl restart nginx

echo "Deployment complete. Check systemd service status and nginx logs if needed."
