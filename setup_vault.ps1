# Script PowerShell para configurar Ansible Vault en Windows
# Uso: .\setup_vault.ps1

Write-Host "=== Configuración de Ansible Vault ===" -ForegroundColor Cyan

# Solicitar contraseña del vault
$vaultPassword = Read-Host "Ingresa una contraseña para el vault (mínimo 20 caracteres)" -AsSecureString
$passwordPlainText = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($vaultPassword)
)

if ($passwordPlainText.Length -lt 20) {
    Write-Host "ERROR: La contraseña debe tener al menos 20 caracteres" -ForegroundColor Red
    exit 1
}

# Crear archivo de contraseña
$vaultPassFile = ".vault_pass.txt"
$passwordPlainText | Out-File -FilePath $vaultPassFile -Encoding ASCII -NoNewline

Write-Host "✓ Archivo de contraseña creado: $vaultPassFile" -ForegroundColor Green

# Proteger el archivo (solo lectura para el usuario actual)
$acl = Get-Acl $vaultPassFile
$acl.SetAccessRuleProtection($true, $false)
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
    $env:USERNAME, "FullControl", "Allow"
)
$acl.SetAccessRule($accessRule)
Set-Acl $vaultPassFile $acl

Write-Host "✓ Permisos configurados" -ForegroundColor Green

# Crear archivo vault.yml con plantilla
$vaultContent = @"
---
# Credenciales Linux
vault_linux_ssh_password: "CAMBIAR_ESTO"
vault_linux_sudo_password: "CAMBIAR_ESTO"

# Credenciales Windows
vault_windows_admin_password: "CAMBIAR_ESTO"
vault_windows_user_password: "CAMBIAR_ESTO"

# Credenciales de servicios
vault_mysql_root_password: "CAMBIAR_ESTO"
vault_postgres_password: "CAMBIAR_ESTO"

# API Keys (si es necesario)
vault_api_key: "CAMBIAR_ESTO"
"@

$vaultDir = "group_vars\all"
if (-not (Test-Path $vaultDir)) {
    New-Item -ItemType Directory -Path $vaultDir -Force | Out-Null
}

$vaultFile = "$vaultDir\vault.yml"
$vaultContent | Out-File -FilePath $vaultFile -Encoding UTF8

Write-Host "✓ Plantilla vault.yml creada en: $vaultFile" -ForegroundColor Green

# Encriptar el archivo
Write-Host "`nEncriptando vault.yml..." -ForegroundColor Yellow
ansible-vault encrypt $vaultFile --vault-password-file=$vaultPassFile

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Archivo vault.yml encriptado correctamente" -ForegroundColor Green
    Write-Host "`nPara editar el archivo:" -ForegroundColor Cyan
    Write-Host "  ansible-vault edit $vaultFile" -ForegroundColor White
    Write-Host "`nPara ver el contenido:" -ForegroundColor Cyan
    Write-Host "  ansible-vault view $vaultFile" -ForegroundColor White
} else {
    Write-Host "ERROR: No se pudo encriptar el archivo" -ForegroundColor Red
    Write-Host "Asegúrate de tener Ansible instalado" -ForegroundColor Yellow
}

Write-Host "`n=== Configuración completada ===" -ForegroundColor Cyan
Write-Host "IMPORTANTE: Nunca commitees .vault_pass.txt a Git" -ForegroundColor Red
