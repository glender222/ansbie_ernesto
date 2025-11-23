- 🐧 **Soporte Linux** (Ubuntu, CentOS, Debian, RHEL)
- 🪟 **Soporte Windows** (Windows 10/11, Server 2016+)
- 🎯 **12 Roles Personalizados** (2 por módulo)
- 📦 **Integración con Galaxy Roles** (geerlingguy.*)
- 🔀 **Playbook Router Principal** con menú interactivo

## 📁 Estructura del Proyecto

```
ansible_oficial/
├── main_router.yml              # 🎯 Playbook maestro - punto de entrada principal
├── ansible.cfg                  # Configuración Ansible
├── requirements.yml             # Galaxy roles/collections
│
├── inventory/
│   └── hosts                    # Inventario de VMs (Linux + Windows)
│
├── group_vars/
│   ├── all/
│   │   ├── main.yml            # Variables globales
│   │   └── vault.yml           # 🔐 Credenciales encriptadas
│   ├── linux_servers.yml       # Variables Linux
│   └── windows_servers.yml     # Variables Windows
│
├── playbooks/                   # 📘 Playbooks por módulo
│   ├── 01_users_management.yml
│   ├── 02_security_firewall.yml
│   ├── 03_scheduled_tasks.yml
│   ├── 04_software_provisioning.yml
│   ├── 05_monitoring.yml
│   └── 06_storage_management.yml
│
├── roles/                       # 🎭 Roles personalizados
│   ├── users_linux/
│   ├── users_windows/
│   ├── firewall_linux/
│   ├── firewall_windows/
│   ├── scheduled_tasks_linux/
│   ├── scheduled_tasks_windows/
│   ├── software_linux/
│   ├── software_windows/
│   ├── monitoring_linux/
│   ├── monitoring_windows/
│   ├── storage_linux/
│   └── storage_windows/
│
└── docs/                        # 📚 Documentación
    ├── SETUP_VIRTUALBOX.md     # Guía configuración VMs
    ├── SETUP_WSL.md            # 🐧 Guía para Windows/WSL
    └── VAULT_USAGE.md          # Guía de Ansible Vault
```

## 🎯 Los 6 Módulos

| # | Módulo | Descripción | Linux | Windows |
|---|--------|-------------|-------|---------|
| 1️⃣ | **Gestión de Usuarios** | Crear usuarios, grupos, SSH, sudo | ✅ | ✅ |
| 2️⃣ | **Seguridad y Firewall** | Firewall, reglas, políticas | ✅ | ✅ |
| 3️⃣ | **Automatización** | Cron jobs, Scheduled Tasks | ✅ | ✅ |
| 4️⃣ | **Software Provisioning** | Paquetes, servicios, Chocolatey | ✅ | ✅ |
| 5️⃣ | **Monitoreo** | Servicios, procesos, recursos | ✅ | ✅ |
| 6️⃣ | **Storage** | Discos, directorios, LVM | ✅ | ✅ |

---

## 🖥️ Tu Configuración Actual

Este proyecto está configurado para:

| Sistema | Hostname | IP | Usuario | Password |
|---------|----------|-----|---------|----------|
| **Linux Mint** | glender-vm | 192.168.11.137 | glender | 123456 |
| **Windows 10 Home** | ansib-win10 | 192.168.11.138 | ansib | Abc123#* |

**Red:** 192.168.11.0/24 (VMware)

**Ubicación del proyecto:**
- Windows: `C:\ernesto_ansible\ansible_oficial\`
- WSL: `/mnt/c/ernesto_ansible/ansible_oficial/`

---

## 🚀 Inicio Rápido

### ⚡ Configuración Automática (NUEVO - Recomendado)

Si ya tienes las VMs creadas, usa el script de configuración rápida:

```bash
# En WSL
cd /mnt/c/ernesto_ansible/ansible_oficial
chmod +x quick_setup.sh
./quick_setup.sh
```

**Este script configura automáticamente:**
- ✅ Ansible Vault con tus credenciales
- ✅ Archivo de contraseña del vault
- ✅ Verifica la configuración

**Credenciales incluidas por defecto:**
- Linux Mint: `123456`
- Windows 10: `Abc123#*` / PIN: `456123`

> 💡 **Tip**: Edita `quick_setup.sh` antes de ejecutarlo si quieres cambiar las credenciales por defecto.

---

### 📚 Configuración Manual (Si prefieres hacerlo paso a paso)

### 0. ¿Estás en Windows? Usa WSL (Recomendado)

Si estás en una laptop Windows, **usa WSL** para ejecutar Ansible:

```bash
# En PowerShell (Administrador)
wsl --install -d Ubuntu-22.04

# Luego instala Ansible dentro de WSL
# Ver guía completa: docs/SETUP_WSL.md
```

**📖 Guía completa de WSL**: [docs/SETUP_WSL.md](docs/SETUP_WSL.md)

### 1. Instalar Dependencias

```bash
# Desde WSL (Ubuntu) o Linux
sudo apt update
sudo apt install -y ansible python3 python3-pip

# Instalar pywinrm para Windows
pip3 install pywinrm

# Instalar Galaxy collections
ansible-galaxy install -r requirements.yml
```

**En Windows con PowerShell** (alternativa, NO recomendado):
```powershell
pip install ansible pywinrm
ansible-galaxy install -r requirements.yml
```

### 2. Configurar Ansible Vault

```bash
# En Windows (PowerShell)
.\setup_vault.ps1

# En Linux/Mac
chmod +x setup_vault.sh
./setup_vault.sh
```

### 3. Configurar Inventario

Edita `inventory/hosts` con las IPs de tus VMs:

```ini
[linux_servers]
ubuntu-vm1 ansible_host=192.168.56.101 ansible_user=ansible

[windows_servers]
windows-vm1 ansible_host=192.168.56.201
```

### 4. Verificar Conectividad

```bash
# Test Linux
ansible linux_servers -m ping

# Test Windows
ansible windows_servers -m win_ping
```

## 💻 Uso del Router Principal

### Ejecutar Todos los Módulos

```bash
ansible-playbook main_router.yml
```

### Ejecutar Módulo Específico

```bash
# Solo usuarios (Módulo 1)
ansible-playbook main_router.yml -e "module=1"

# Solo firewall (Módulo 2)
ansible-playbook main_router.yml -e "module=2"
```

### Ejecutar Varios Módulos

```bash
# Módulos 1, 2 y 3
ansible-playbook main_router.yml -e "modules=1,2,3"
```

### Ejecutar con Tags

```bash
# Solo tareas de usuarios
ansible-playbook main_router.yml --tags users

# Solo para Linux
ansible-playbook main_router.yml --tags linux

# Verificación únicamente
ansible-playbook main_router.yml --tags info
```

## 🔐 Seguridad con Ansible Vault

Todas las credenciales están encriptadas en `group_vars/all/vault.yml`:

```bash
# Ver credenciales
ansible-vault view group_vars/all/vault.yml

# Editar credenciales
ansible-vault edit group_vars/all/vault.yml

# Cambiar contraseña del vault
ansible-vault rekey group_vars/all/vault.yml
```

Ver guía completa: [docs/VAULT_USAGE.md](docs/VAULT_USAGE.md)

## 🖥️ Configuración de VirtualBox

### Red Host-Only

1. Crear adaptador: 192.168.56.1/24
2. Configurar VMs con 2 adaptadores:
   - Adaptador 1: NAT (internet)
   - Adaptador 2: Host-only (Ansible)

### VMs Recomendadas

| VM | OS | IP | RAM | Disco |
|----|----|----|-----|-------|
| ubuntu-vm1 | Ubuntu 22.04 | 192.168.56.101 | 2GB | 20GB |
| windows-vm1 | Windows 10 | 192.168.56.201 | 4GB | 40GB |

Ver guía completa: [docs/SETUP_VIRTUALBOX.md](docs/SETUP_VIRTUALBOX.md)

## 📚 Documentación por Módulo

Cada rol tiene su propio README con ejemplos:

- [roles/users_linux/README.md](roles/users_linux/README.md)
- [roles/users_windows/README.md](roles/users_windows/README.md)
- Y así para todos los roles...

## 🎨 Personalización

### Modificar Variables

Edita las variables en `group_vars/`:

```yaml
# group_vars/all/main.yml
modules_enabled:
  users_management: true
  security_firewall: true
  # ...

# group_vars/linux_servers.yml
linux_packages:
  - vim
  - git
  - htop
```

### Añadir Nuevos Roles

```bash
# Crear estructura de rol
mkdir -p roles/mi_rol/{tasks,defaults,handlers,templates}

# Añadir a playbook correspondiente
# playbooks/XX_mi_modulo.yml
```

## 🔧 Troubleshooting

### Error: "Vault password file not found"

```bash
echo "tu-contraseña" > .vault_pass.txt
chmod 600 .vault_pass.txt
```

### Error: Windows WinRM no responde

```powershell
# En la VM Windows
winrm quickconfig
winrm set winrm/config/service/auth '@{Basic="true"}'
```

### Error: SSH connection refused (Linux)

```bash
# En la VM Linux
sudo systemctl start sshd
sudo systemctl enable sshd
```

## 📊 Tags Disponibles

- `users` - Gestión de usuarios
- `security` - Configuración de seguridad
- `firewall` - Reglas de firewall
- `cron` / `scheduled_tasks` - Tareas programadas
- `software` - Instalación de software
- `monitoring` - Monitoreo
- `storage` - Gestión de almacenamiento
- `info` - Solo mostrar información
- `linux` - Solo hosts Linux
- `windows` - Solo hosts Windows

## 🤝 Contribuir

1. Fork el proyecto
2. Crea una rama: `git checkout -b feature/nueva-funcionalidad`
3. Commit: `git commit -am 'Añadir nueva funcionalidad'`
4. Push: `git push origin feature/nueva-funcionalidad`
5. Pull Request
**En Windows con PowerShell** (alternativa, NO recomendado):
```powershell
pip install ansible pywinrm
ansible-galaxy install -r requirements.yml
```

### 2. Configurar Ansible Vault

```bash
# En Windows (PowerShell)
.\setup_vault.ps1

# En Linux/Mac
chmod +x setup_vault.sh
./setup_vault.sh
```

### 3. Configurar Inventario

Edita `inventory/hosts` con las IPs de tus VMs:

```ini
[linux_servers]
ubuntu-vm1 ansible_host=192.168.56.101 ansible_user=ansible

[windows_servers]
windows-vm1 ansible_host=192.168.56.201
```

### 4. Verificar Conectividad

```bash
# Test Linux
ansible linux_servers -m ping

# Test Windows
ansible windows_servers -m win_ping
```

## 💻 Uso del Router Principal

### Ejecutar Todos los Módulos

```bash
ansible-playbook main_router.yml
```

### Ejecutar Módulo Específico

```bash
# Solo usuarios (Módulo 1)
ansible-playbook main_router.yml -e "module=1"

# Solo firewall (Módulo 2)
ansible-playbook main_router.yml -e "module=2"
```

### Ejecutar Varios Módulos

```bash
# Módulos 1, 2 y 3
ansible-playbook main_router.yml -e "modules=1,2,3"
```

### Ejecutar con Tags

```bash
# Solo tareas de usuarios
ansible-playbook main_router.yml --tags users

# Solo para Linux
ansible-playbook main_router.yml --tags linux

# Verificación únicamente
ansible-playbook main_router.yml --tags info
```

## 🔐 Seguridad con Ansible Vault

Todas las credenciales están encriptadas en `group_vars/all/vault.yml`:

```bash
# Ver credenciales
ansible-vault view group_vars/all/vault.yml

# Editar credenciales
ansible-vault edit group_vars/all/vault.yml

# Cambiar contraseña del vault
ansible-vault rekey group_vars/all/vault.yml
```

Ver guía completa: [docs/VAULT_USAGE.md](docs/VAULT_USAGE.md)

## 🖥️ Configuración de VirtualBox

### Red Host-Only

1. Crear adaptador: 192.168.56.1/24
2. Configurar VMs con 2 adaptadores:
   - Adaptador 1: NAT (internet)
   - Adaptador 2: Host-only (Ansible)

### VMs Recomendadas

| VM | OS | IP | RAM | Disco |
|----|----|----|-----|-------|
| ubuntu-vm1 | Ubuntu 22.04 | 192.168.56.101 | 2GB | 20GB |
| windows-vm1 | Windows 10 | 192.168.56.201 | 4GB | 40GB |

Ver guía completa: [docs/SETUP_VIRTUALBOX.md](docs/SETUP_VIRTUALBOX.md)

## 📚 Documentación por Módulo

Cada rol tiene su propio README con ejemplos:

- [roles/users_linux/README.md](roles/users_linux/README.md)
- [roles/users_windows/README.md](roles/users_windows/README.md)
- Y así para todos los roles...

## 🎨 Personalización

### Modificar Variables

Edita las variables en `group_vars/`:

```yaml
# group_vars/all/main.yml
modules_enabled:
  users_management: true
  security_firewall: true
  # ...

# group_vars/linux_servers.yml
linux_packages:
  - vim
  - git
  - htop
```

### Añadir Nuevos Roles

```bash
# Crear estructura de rol
mkdir -p roles/mi_rol/{tasks,defaults,handlers,templates}

# Añadir a playbook correspondiente
# playbooks/XX_mi_modulo.yml
```

## 🔧 Troubleshooting

### Error: "Vault password file not found"

```bash
echo "tu-contraseña" > .vault_pass.txt
chmod 600 .vault_pass.txt
```

### Error: Windows WinRM no responde

```powershell
# En la VM Windows
winrm quickconfig
winrm set winrm/config/service/auth '@{Basic="true"}'
```

### Error: SSH connection refused (Linux)

```bash
# En la VM Linux
sudo systemctl start sshd
sudo systemctl enable sshd
```

## 📊 Tags Disponibles

- `users` - Gestión de usuarios
- `security` - Configuración de seguridad
- `firewall` - Reglas de firewall
- `cron` / `scheduled_tasks` - Tareas programadas
- `software` - Instalación de software
- `monitoring` - Monitoreo
- `storage` - Gestión de almacenamiento
- `info` - Solo mostrar información
- `linux` - Solo hosts Linux
- `windows` - Solo hosts Windows

## 🤝 Contribuir

1. Fork el proyecto
2. Crea una rama: `git checkout -b feature/nueva-funcionalidad`
3. Commit: `git commit -am 'Añadir nueva funcionalidad'`
4. Push: `git push origin feature/nueva-funcionalidad`
5. Pull Request

## 📝 Licencia

MIT License

## 📚 Tabla de Contenido

- **[⚡ START_HERE.md](START_HERE.md)** ← Empieza aquí si ya tienes todo
- [Características](#-características)
- [Arquitectura](#️-arquitectura-del-proyecto)
- [Módulos](#-módulos-implementados)
- [Inicio Rápido](#-inicio-rápido)
- [Configuración Actual](#-tu-configuración-actual)
- [Uso](#-uso)
- [Documentación](#-documentación)
- [Troubleshooting](#-troubleshooting)

## 👤 Autor

Proyecto creado para gestión de infraestructura multi-plataforma con Ansible.

---

**📖 Para más información:**
- [Documentación de Ansible](https://docs.ansible.com/)
- [Ansible Galaxy](https://galaxy.ansible.com/)
- [Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)
