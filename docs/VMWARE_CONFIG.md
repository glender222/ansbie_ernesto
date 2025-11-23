# 🔧 Configuración Rápida para VMware

Esta guía te muestra **exactamente qué archivos editar** para adaptar el proyecto a VMware.

## 📝 Archivos que DEBES Editar

### 1. Inventario (OBLIGATORIO)

**Archivo:** `inventory/hosts`

Descomentar y configurar con IPs de VMware:

```ini
[linux_servers]
ansible-ubuntu-01 ansible_host=192.168.137.101 ansible_user=ansible

[ubuntu_servers]
ansible-ubuntu-01

[windows_servers]
# windows-vm1 ansible_host=192.168.137.201
```

**IPs para VMware:**
- Red Host-Only: `192.168.137.0/24`
- Primera VM Linux: `192.168.137.101`
- Segunda VM Linux: `192.168.137.102`
- Primera VM Windows: `192.168.137.201`
- Segunda VM Windows: `192.168.137.202`

---

### 2. Ansible Vault (OBLIGATORIO)

**Archivo:** `group_vars/all/vault.yml`

Configurar con el script:

```bash
# En WSL
cd /mnt/c/ernesto_ansible/ansible_oficial
./setup_vault.sh
```

Luego editar:

```bash
ansible-vault edit group_vars/all/vault.yml
```

Contenido:

```yaml
---
# Credenciales Linux
vault_linux_ssh_password: "tu-password-de-vm-linux"
vault_linux_sudo_password: "tu-password-de-vm-linux"

# Credenciales Windows
vault_windows_admin_password: "tu-password-de-vm-windows"
vault_windows_user_password: "tu-password-de-vm-windows"

# Otros (si los necesitas)
vault_mysql_root_password: "mysql-pass-123"
vault_postgres_password: "postgres-pass-123"
vault_api_key: "api-key-here"
```

---

## 📋 Archivos YML que NO Necesitas Cambiar

Estos archivos ya están configurados correctamente y usan **variables**, no IPs hardcodeadas:

✅ `ansible.cfg` - Ya configurado con vault
✅ `requirements.yml` - No tiene IPs
✅ `group_vars/all/main.yml` - Variables globales
✅ `group_vars/linux_servers.yml` - Variables Linux
✅ `group_vars/windows_servers.yml` - Variables Windows (tiene referencia a vault)
✅ Todos los `roles/*/defaults/main.yml` - Usan variables
✅ Todos los `roles/*/tasks/main.yml` - Usan variables
✅ Todos los `playbooks/*.yml` - Usan inventario

---

## 🎯 Checklist de Configuración

Antes de ejecutar playbooks:

- [ ] **VMware instalado** y configurado
- [ ] **VM Ubuntu creada** con IP 192.168.137.101
- [ ] **Inventario actualizado** (`inventory/hosts`)
- [ ] **Vault configurado** (`./setup_vault.sh`)
- [ ] **Credenciales en vault** (`ansible-vault edit group_vars/all/vault.yml`)
- [ ] **Test de conectividad**: `ansible all -m ping`

---

## 🔍 Verificación Rápida

### Test 1: Ver el inventario

```bash
ansible-inventory --list
```

Deberías ver tus hosts con las IPs de VMware (192.168.137.x).

### Test 2: Ping a Linux

```bash
ansible linux_servers -m ping
```

Debería responder:
```
ansible-ubuntu-01 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

### Test 3: Ping a Windows (si tienes VM Windows)

```bash
ansible windows_servers -m win_ping
```

---

## 🚀 Primer Uso Después de Configurar

Una vez configurado todo:

```bash
# 1. Syntax check
ansible-playbook main_router.yml --syntax-check

# 2. Dry-run (sin hacer cambios)
ansible-playbook main_router.yml -e "module=5" --check

# 3. Ejecución real (módulo de monitoreo)
ansible-playbook main_router.yml -e "module=5"

# 4. Si todo funciona, ejecutar módulo 1
ansible-playbook main_router.yml -e "module=1"
```

---

## 📊 Comparación de Redes

| Virtualización | Red Host-Only | Rango IPs | Gateway Host |
|----------------|---------------|-----------|--------------|
| **VirtualBox** | vboxnet0 | 192.168.56.0/24 | 192.168.56.1 |
| **VMware** | VMnet1 | 192.168.137.0/24 | 192.168.137.1 |

---

## ⚠️ Errores Comunes

### Error: "No hosts matched"

```
SOLUCIÓN:
- Verificar inventory/hosts
- Asegurarte de descomentar las líneas
- Verificar que las IPs sean correctas (192.168.137.x)
```

### Error: "Permission denied (publickey,password)"

```
SOLUCIÓN:
# Opción 1: Usar --ask-pass
ansible-playbook main_router.yml --ask-pass

# Opción 2: SSH key
ssh-copy-id ansible@192.168.137.101
```

### Error: "Vault password file not found"

```
SOLUCIÓN:
./setup_vault.sh
# Seguir las instrucciones para crear .vault_pass.txt
```

---

## 💡 Tips

1. **Snapshots antes de cada módulo**: 
   ```
   VMware → VM → Snapshot → Take Snapshot
   Nombre: "Before Module 1 - Users"
   ```

2. **Clonar VMs fácilmente** (VMware Pro):
   ```
   VM → Manage → Clone
   Cambiar IP estática en la VM clonada
   Actualizar inventory/hosts
   ```

3. **Editar archivos desde Windows**:
   ```
   Los archivos en /mnt/c/ernesto_ansible/ansible_oficial/
   son los mismos que C:\ernesto_ansible\ansible_oficial\
   
   Edita con tu editor favorito y ejecuta desde WSL
   ```

---

## 🎉 Resumen

**Solo necesitas editar 2 archivos:**

1. **`inventory/hosts`** ← IPs de tus VMs
2. **`group_vars/all/vault.yml`** ← Contraseñas (usando `ansible-vault edit`)

**Todo lo demás ya está configurado** para funcionar con cualquier plataforma de virtualización. 🚀
