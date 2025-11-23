# ⚡ Guía de Inicio Ultra-Rápido

Esta guía te lleva de **0 a ejecutando Ansible en 5 minutos**.

## ✅ Prerequisitos

Antes de empezar, asegúrate de tener:

- [x] **WSL instalado** en Windows
- [x] **VMware Workstation** instalado
- [x] **VMs creadas y encendidas**:
  - Linux Mint: `192.168.11.137`
  - Windows 10: `192.168.11.138`
- [x] **SSH funcionando** en Linux
- [x] **WinRM configurado** en Windows

---

## 🚀 Configuración en 3 Pasos

### Paso 1: Abrir WSL

```bash
# Desde PowerShell o Terminal de Windows
wsl
```

### Paso 2: Ir al proyecto

```bash
cd /mnt/c/ernesto_ansible/ansible_oficial
```

### Paso 3: Ejecutar script de configuración

```bash
# Dar permisos
chmod +x quick_setup.sh

# Ejecutar
./quick_setup.sh
```

**¡Eso es todo!** El script configura:
- ✅ Ansible Vault con credenciales
- ✅ Archivo de contraseña
- ✅ Verificación automática

---

## ✅ Verificar que Funciona

```bash
# Test de conectividad
ansible all -m ping

# Deberías ver:
# glender-vm | SUCCESS => {"ping": "pong"}
# ansib-win10 | SUCCESS => {"ping": "pong"}
```

---

## 🎯 Ejecutar Primer Módulo

```bash
# Módulo de monitoreo (solo lee, no cambia nada)
ansible-playbook main_router.yml -e "module=5"

# Módulo de usuarios
ansible-playbook main_router.yml -e "module=1"

# Todos los módulos
ansible-playbook main_router.yml
```

---

## 📊 Tabla de Comandos Rápidos

| Acción | Comando |
|--------|---------|
| **Ver inventario** | `ansible-inventory --list` |
| **Ping a VMs** | `ansible all -m ping` |
| **Listar VMs** | `ansible-playbook utils/list_vms.yml` |
| **Ejecutar módulo específico** | `ansible-playbook main_router.yml -e "module=X"` |
| **Ejecutar todos** | `ansible-playbook main_router.yml` |
| **Ver vault** | `ansible-vault view group_vars/all/vault.yml` |
| **Editar vault** | `ansible-vault edit group_vars/all/vault.yml` |

---

## 🔑 Credenciales Configuradas

El script `quick_setup.sh` configura estas credenciales por defecto:

| Sistema | Usuario | Password | Nota |
|---------|---------|----------|------|
| **Linux Mint** | glender | 123456 | SSH y sudo |
| **Windows 10** | ansib | Abc123#* | Admin |
| **Windows PIN** | - | 456123 | Opcional |

---

## ⚙️ Personalizar Credenciales

Si quieres usar otras credenciales:

### Opción 1: Editar script antes de ejecutar

```bash
# Editar quick_setup.sh
nano quick_setup.sh

# Cambiar las líneas:
vault_linux_ssh_password: "TU_PASSWORD"
vault_windows_admin_password: "TU_PASSWORD"
```

### Opción 2: Editar vault después

```bash
# Editar vault
ansible-vault edit group_vars/all/vault.yml

# Cambiar las contraseñas
# Guardar: Ctrl+O, Enter, Ctrl+X
```

---

## 🐛 Troubleshooting

### Error: "ansible: command not found"

```bash
# Instalar Ansible en WSL
sudo apt update
sudo apt install -y ansible
```

### Error: "Permission denied"

```bash
# Dar permisos al script
chmod +x quick_setup.sh
```

### Error: Ping falla a Linux

```bash
# Verificar SSH en la VM Linux
ssh glender@192.168.11.137

# Si falla, en la VM Linux:
sudo systemctl start ssh
sudo systemctl enable ssh
```

### Error: Ping falla a Windows

```bash
# Verificar WinRM en Windows
# En PowerShell de la VM Windows:
winrm enumerate winrm/config/listener

# Reinstalar pywinrm en WSL
pip3 install --upgrade pywinrm
```

---

## 📚 Siguientes Pasos

Una vez que `ansible all -m ping` funcione:

1. **Ejecutar módulos de prueba**:
   ```bash
   ansible-playbook main_router.yml -e "module=5"
   ```

2. **Ver documentación de módulos**:
   - `docs/LINUX_MINT_WIN10.md` - Guía específica de tus VMs
   - `README.md` - Documentación completa
   - `roles/*/README.md` - Documentación de cada rol

3. **Crear más VMs**:
   - Clonar VMs en VMware
   - Actualizar `inventory/hosts`
   - Ejecutar playbooks

---

## 🎉 Resumen

**Todo el proceso:**

```bash
# 1. Abrir WSL
wsl

# 2. Ir al proyecto
cd /mnt/c/ernesto_ansible/ansible_oficial

# 3. Ejecutar setup
chmod +x quick_setup.sh && ./quick_setup.sh

# 4. Probar
ansible all -m ping

# 5. Ejecutar
ansible-playbook main_router.yml -e "module=5"
```

**¡De 0 a Ansible funcionando en 5 minutos!** 🚀

---

## 💡 Comandos Copy-Paste

Para los más impacientes:

```bash
wsl
cd /mnt/c/ernesto_ansible/ansible_oficial
chmod +x quick_setup.sh && ./quick_setup.sh && ansible all -m ping && ansible-playbook main_router.yml -e "module=5"
```

**Una sola línea hace:**
1. ✅ Abre WSL
2. ✅ Va al proyecto
3. ✅ Configura todo
4. ✅ Prueba conectividad
5. ✅ Ejecuta módulo de monitoreo

---

**¿Problemas? Revisa la sección de Troubleshooting arriba o consulta `docs/LINUX_MINT_WIN10.md` para la guía detallada.** 📖
