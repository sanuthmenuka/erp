#!/bin/bash
set -euo pipefail

echo "=== QuickBite ERP - Odoo 19 dev environment setup ==="
cd /workspace

# Odoo core is a pinned git submodule (see .gitmodules). Never edit it.
echo "Fetching Odoo core submodule..."
git config --global --add safe.directory /workspace
git config --global --add safe.directory /workspace/odoo
git submodule update --init --depth 1 odoo

# Python virtual environment (kept on the bind mount, gitignored)
if [ ! -x /workspace/.venv/bin/python ]; then
    echo "Creating Python virtual environment..."
    python3 -m venv /workspace/.venv
fi
source /workspace/.venv/bin/activate
pip install --upgrade pip wheel setuptools
pip install -r /workspace/odoo/requirements.txt
pip install -r /workspace/requirements-dev.txt

echo "Waiting for PostgreSQL..."
until pg_isready -h db -U odoo; do sleep 2; done
PGPASSWORD=odoo psql -h db -U odoo -d odoo -c "CREATE EXTENSION IF NOT EXISTS vector;" || true

mkdir -p /workspace/.odoo-data /workspace/db/backups
chmod +x /workspace/scripts/*
grep -q '/workspace/scripts' ~/.bashrc || echo 'export PATH="/workspace/scripts:$PATH"' >> ~/.bashrc

# Git hooks (ruff, xml checks) - see .pre-commit-config.yaml
pre-commit install || true

echo ""
echo "=== Setup complete ==="
echo "Start Odoo:   odoo-start          -> http://localhost:8069"
echo "Workflow:     see /workspace/README.md"
