#!/bin/bash
set -e

echo "=== Odoo Development Environment Setup ==="

cd /workspace

# Clone Odoo Community if not exists
if [ ! -d "/workspace/odoo" ]; then
    echo "Cloning Odoo Community 19.0..."
    git clone --branch 19.0 --single-branch --depth 1 https://github.com/odoo/odoo.git /workspace/odoo
else
    echo "Odoo Community already exists, skipping clone."
fi

# Create Python virtual environment
echo "Creating Python virtual environment..."
python3 -m venv /workspace/.venv

# Activate virtual environment and install dependencies
echo "Installing Python dependencies..."
source /workspace/.venv/bin/activate
pip install --upgrade pip wheel setuptools

# Install Odoo requirements
if [ -f "/workspace/odoo/requirements.txt" ]; then
    pip install -r /workspace/odoo/requirements.txt
fi

# Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL..."
until pg_isready -h db -U odoo; do
    sleep 2
done

# Enable pg_vector extension
echo "Enabling pg_vector extension..."
PGPASSWORD=odoo psql -h db -U odoo -d odoo -c "CREATE EXTENSION IF NOT EXISTS vector;" || true

# Add scripts to PATH
echo 'export PATH="/workspace/scripts:$PATH"' >> ~/.bashrc
chmod +x /workspace/scripts/*

echo ""
echo "=== Setup Complete ==="
echo ""
echo "To start Odoo, run: odoo-start"
echo "Odoo will be available at: http://localhost:8069"
