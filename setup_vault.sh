#!/bin/bash
# Script Bash para configurar Ansible Vault en Linux/Mac
# Uso: ./setup_vault.sh

set -e

echo "=== Configuración de Ansible Vault ==="
echo

# Solicitar contraseña
echo "Ingresa una contraseña para el vault (mínimo 20 caracteres):"
read -s vault_password
echo

if [ ${#vault_password} -lt 20 ]; then
    echo "ERROR: La contraseña debe tener al menos 20 caracteres"
    exit 1
fi

# Crear archivo de contraseña
vault_pass_file=".vault_pass.txt"
echo -n "$vault_password" > "$vault_pass_file"
chmod 600 "$vault_pass_file"

echo "✓ Archivo de contraseña creado: $vault_pass_file"

# Crear directorio si no existe
mkdir -p group_vars/all

# Crear archivo vault.yml con plantilla
cat > group_vars/all/vault.yml << 'EOF'
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
EOF

echo "✓ Plantilla vault.yml creada"

# Encriptar el archivo
echo
echo "Encriptando vault.yml..."
ansible-vault encrypt group_vars/all/vault.yml --vault-password-file="$vault_pass_file"

echo
echo "✓ Archivo vault.yml encriptado correctamente"
echo
echo "Para editar el archivo:"
echo "  ansible-vault edit group_vars/all/vault.yml"
echo
echo "Para ver el contenido:"
echo "  ansible-vault view group_vars/all/vault.yml"
echo
echo "=== Configuración completada ==="
echo "IMPORTANTE: Nunca commitees .vault_pass.txt a Git"
