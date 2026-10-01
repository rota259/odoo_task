# One-command local Odoo setup for the 2S Home Wear app (Windows PowerShell).
# Starts Docker services, creates `odoo_demo` with demo data, installs Sales,
# ensures admin/demo/portal users, customers and draft quotations.
# Idempotent: safe to re-run.
# Native tools write progress to stderr; rely on $LASTEXITCODE instead.
$ErrorActionPreference = 'Continue'
Set-Location -Path $PSScriptRoot

Write-Host '[setup] Starting containers...'
docker compose up -d
if ($LASTEXITCODE -ne 0) { throw 'docker compose up failed' }

Write-Host '[setup] Waiting for the Odoo container to accept commands...'
do {
    docker compose exec -T odoo true *> $null
    $ready = $LASTEXITCODE -eq 0
    if (-not $ready) { Start-Sleep -Seconds 2 }
} until ($ready)

# The provisioning logic runs inside the odoo container (it ships Python 3),
# so the host needs nothing but Docker.
Get-Content -Raw -Path (Join-Path $PSScriptRoot 'setup_odoo.py') |
    docker compose exec -T odoo python3 -
if ($LASTEXITCODE -ne 0) { throw 'Odoo provisioning failed' }
