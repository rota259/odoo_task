#!/usr/bin/env sh
# One-command local Odoo setup for the 2S Home Wear app.
# Starts Docker services, creates `odoo_demo` with demo data, installs Sales,
# ensures admin/demo/portal users, customers and draft quotations.
# Idempotent: safe to re-run.
set -eu
cd "$(dirname "$0")"

echo "[setup] Starting containers..."
docker compose up -d

echo "[setup] Waiting for the Odoo container to accept commands..."
until docker compose exec -T odoo true >/dev/null 2>&1; do sleep 2; done

# The provisioning logic runs inside the odoo container (it ships Python 3),
# so the host needs nothing but Docker.
docker compose exec -T odoo python3 - < setup_odoo.py
