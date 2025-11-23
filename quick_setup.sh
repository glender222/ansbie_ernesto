#!/bin/bash
# Script de configuración rápida de Ansible con credenciales
# Uso: ./quick_setup.sh

set -e  # Salir si hay error

echo "╔════════════════════════════════════════════════════════════╗"
echo "║   CONFIGURACIÓN RÁPIDA DE ANSIBLE                        ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Variables
VAULT_PASS_FILE=".vault_pass.txt"
VAULT_FILE="group_vars/all/vault.yml"

# 1. Crear contraseña del vault
echo -e "${YELLOW}[1/5] Creando contraseña del vault...${NC}"
echo "ansible_vault_password_2024" > "$VAULT_PASS_FILE"
chmod 600 "$VAULT_PASS_FILE"
echo -e "${GREEN}✓ Archivo .vault_pass.txt creado${NC}"
echo

# 2. Crear directorio si no existe
echo -e "${YELLOW}[2/5] Verificando directorios...${NC}"
mkdir -p group_vars/all
echo -e "${GREEN}✓ Directorios verificados${NC}"
echo

# 3. Crear archivo vault temporal con credenciales
echo -e "${YELLOW}[3/5] Creando archivo vault con credenciales...${NC}"
cat > /tmp/vault_temp.yml << 'EOF'
---
# ============================================
# Credenciales Linux Mint
# ============================================
vault_linux_ssh_password: "123456"
vault_linux_sudo_password: "123456"

# ============================================
# Credenciales Windows 10
# ============================================
vault_windows_admin_password: "Abc123#*"
vault_windows_user_password: "456123"

# ============================================
# Credenciales de Bases de Datos (opcionales)
# ============================================
vault_mysql_root_password: "mysql_default_pass_2024"
vault_postgres_password: "postgres_default_pass_2024"

# ============================================
# Otras credenciales (personalizables)
# ============================================
vault_api_key: "api_key_placeholder"
vault_secret_key: "secret_key_placeholder"
EOF

echo -e "${GREEN}✓ Archivo temporal creado${NC}"
echo

# 4. Encriptar el archivo
echo -e "${YELLOW}[4/5] Encriptando credenciales con Ansible Vault...${NC}"
ansible-vault encrypt /tmp/vault_temp.yml --output="$VAULT_FILE" --vault-password-file="$VAULT_PASS_FILE"
rm /tmp/vault_temp.yml
echo -e "${GREEN}✓ Credenciales encriptadas en $VAULT_FILE${NC}"
echo

# 5. Verificar
echo -e "${YELLOW}[5/5] Verificando configuración...${NC}"

# Verificar que ansible.cfg tiene la referencia
if ! grep -q "vault_password_file" ansible.cfg 2>/dev/null; then
    echo -e "${YELLOW}⚠ Actualizando ansible.cfg...${NC}"
    echo "" >> ansible.cfg
    echo "vault_password_file = ./.vault_pass.txt" >> ansible.cfg
fi

# Mostrar archivo encriptado
echo -e "${GREEN}✓ Archivo vault encriptado:${NC}"
head -n 5 "$VAULT_FILE"
echo "..."
echo

# Test de desencriptación
echo -e "${YELLOW}Probando desencriptación...${NC}"
ansible-vault view "$VAULT_FILE" --vault-password-file="$VAULT_PASS_FILE" | head -n 10
echo "..."
echo

echo "╔════════════════════════════════════════════════════════════╗"
echo "║   ✅ CONFIGURACIÓN COMPLETADA                             ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo
echo -e "${GREEN}Archivos creados:${NC}"
echo "  ✓ $VAULT_PASS_FILE (contraseña del vault)"
echo "  ✓ $VAULT_FILE (credenciales encriptadas)"
echo
echo -e "${GREEN}Credenciales configuradas:${NC}"
echo "  • Linux Mint: usuario=glender, password=123456"
echo "  • Windows 10: usuario=ansib, password=Abc123#*"
echo
echo -e "${YELLOW}Próximos pasos:${NC}"
echo "  1. Probar conectividad:"
echo "     ansible all -m ping"
echo
echo "  2. Ejecutar módulo de monitoreo:"
echo "     ansible-playbook main_router.yml -e \"module=5\""
echo
echo "  3. Ejecutar todos los módulos:"
echo "     ansible-playbook main_router.yml"
echo
echo -e "${GREEN}🚀 ¡Todo listo para usar Ansible!${NC}"
