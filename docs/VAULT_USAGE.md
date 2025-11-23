# Guía de Uso de Ansible Vault

Ansible Vault te permite encriptar archivos sensibles para proteger credenciales, claves SSH, contraseñas y otra información confidencial.

## 🔐 Configuración Inicial

### 1. Crear el archivo de contraseña del vault

```bash
# Crear archivo con contraseña (usar una contraseña fuerte)
echo "tu-contraseña-segura-aqui" > .vault_pass.txt

# Proteger el archivo (solo lectura para el propietario)
chmod 600 .vault_pass.txt
```

**⚠️ IMPORTANTE:** Este archivo está en `.gitignore` y NUNCA debe ser commiteado a Git.

### 2. Crear archivo encriptado de credenciales

```bash
# Crear y editar archivo encriptado
ansible-vault create group_vars/all/vault.yml
```

Contenido sugerido para `vault.yml`:

```yaml
---
# Credenciales Linux
vault_linux_ssh_password: "password-linux-123"
vault_linux_sudo_password: "sudo-password-456"

# Credenciales Windows
vault_windows_admin_password: "WindowsAdminPass123!"
vault_windows_user_password: "WindowsUserPass456!"

# Credenciales de servicios
vault_mysql_root_password: "mysql-root-pass-789"
vault_postgres_password: "postgres-pass-012"

# API Keys
vault_api_key: "api-key-here"
vault_secret_token: "secret-token-here"
```

## 📝 Operaciones Comunes

### Ver contenido de archivo encriptado

```bash
ansible-vault view group_vars/all/vault.yml
```

### Editar archivo encriptado

```bash
ansible-vault edit group_vars/all/vault.yml
```

### Encriptar archivo existente

```bash
ansible-vault encrypt mi_archivo.yml
```

### Desencriptar archivo

```bash
ansible-vault decrypt mi_archivo.yml
```

### Cambiar contraseña del vault

```bash
ansible-vault rekey group_vars/all/vault.yml
```

## 🎯 Uso en Playbooks

### Opción 1: Usando archivo de contraseña (configurado en ansible.cfg)

```bash
ansible-playbook main_router.yml
```

### Opción 2: Solicitando contraseña interactivamente

```bash
ansible-playbook main_router.yml --ask-vault-pass
```

### Opción 3: Especificando archivo de contraseña

```bash
ansible-playbook main_router.yml --vault-password-file .vault_pass.txt
```

## 💡 Mejores Prácticas

1. **Nunca commitear** el archivo `.vault_pass.txt`
2. **Usar contraseñas fuertes** con al menos 20 caracteres
3. **Compartir la contraseña** de forma segura (password manager, comunicación cifrada)
4. **Mantener separados** archivos cifrados (`vault.yml`) de variables normales (`main.yml`)
5. **Prefijo `vault_`** para variables encriptadas (ej: `vault_mysql_password`)
6. **Rotar credenciales** periódicamente y actualizar el vault
7. **Backup seguro** de la contraseña del vault

## 🔍 Verificación

### Verificar que un archivo está encriptado

```bash
head -n 1 group_vars/all/vault.yml
# Debe mostrar: $ANSIBLE_VAULT;1.1;AES256
```

### Verificar sintaxis sin ejecutar

```bash
ansible-playbook main_router.yml --syntax-check
```

## 🚨 Troubleshooting

### Error: "Vault password file not found"

```bash
# Verificar que existe el archivo
ls -la .vault_pass.txt

# Verificar configuración
grep vault_password_file ansible.cfg
```

### Error: "Decryption failed"

La contraseña es incorrecta. Verifica:
1. El contenido de `.vault_pass.txt`
2. Que no haya espacios o saltos de línea extra
3. Que uses la misma contraseña con la que se encriptó

### Error: "Bad permissions"

```bash
# En Linux/Mac
chmod 600 .vault_pass.txt

# En Windows (PowerShell como Admin)
icacls .vault_pass.txt /inheritance:r /grant:r "${env:USERNAME}:F"
```

## 📚 Recursos Adicionales

- [Ansible Vault Documentation](https://docs.ansible.com/ansible/latest/user_guide/vault.html)
- [Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html#best-practices-for-variables-and-vaults)
