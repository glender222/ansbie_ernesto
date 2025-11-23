# 🐧 Guía de Configuración en WSL (Windows Subsystem for Linux)

Esta guía te ayudará a configurar y ejecutar el proyecto Ansible desde WSL en tu laptop Windows.

## ✅ Por qué usar WSL

- ✅ **Ansible funciona mejor en Linux** - fue diseñado originalmente para Linux
- ✅ **Compatibilidad 100%** con todos los módulos y roles
- ✅ **Mejor rendimiento** que ejecutar Ansible en PowerShell
- ✅ **Acceso a archivos de Windows** vía `/mnt/c/`
- ✅ **Puede alcanzar VMs de VirtualBox** en el host Windows

## 📋 Requisitos Previos

- Windows 10 versión 2004+ o Windows 11
- WSL 2 instalado
- Ubuntu en WSL (recomendado: Ubuntu 22.04)

---

## 🚀 Configuración Paso a Paso

### 1. Instalar/Verificar WSL

```powershell
# En PowerShell como Administrador

# Verificar si WSL está instalado
wsl --list --verbose

# Si no está instalado, instalar WSL con Ubuntu
wsl --install -d Ubuntu-22.04

# Actualizar a WSL 2 (si es necesario)
wsl --set-default-version 2
```

### 2. Iniciar WSL y Configurar Ubuntu

```bash
# Abrir WSL (desde PowerShell o Terminal de Windows)
wsl

# Actualizar el sistema
sudo apt update && sudo apt upgrade -y
```

### 3. Instalar Ansible en WSL

```bash
# Instalar dependencias
sudo apt install -y software-properties-common python3 python3-pip

# Instalar Ansible
sudo apt install -y ansible

# Verificar instalación
ansible --version

# Debería mostrar algo como: ansible [core 2.xx.x]
```

### 4. Instalar pywinrm para gestión de Windows

```bash
# Necesario para conectar a VMs Windows
pip3 install pywinrm

# Verificar instalación
pip3 list | grep pywinrm
```

### 5. Navegar al Proyecto

Tus archivos de Windows están en `/mnt/c/`:

```bash
# Ir al proyecto
cd /mnt/c/ernesto_ansible/ansible_oficial

# Verificar contenido
ls -la

# Deberías ver: main_router.yml, ansible.cfg, roles/, etc.
```

### 6. Configurar Ansible Vault

```bash
# Usar el script de Linux (desde WSL)
chmod +x setup_vault.sh
./setup_vault.sh

# Seguir las instrucciones para crear contraseña del vault
```

### 7. Editar Inventario

```bash
# Usar un editor en WSL
nano inventory/hosts
# O usar vim
vim inventory/hosts
# O usar VS Code desde WSL
code inventory/hosts
```

Configurar con las IPs de tus VMs de VirtualBox:

```ini
[linux_servers]
ubuntu-vm1 ansible_host=192.168.56.101 ansible_user=ansible

[windows_servers]
windows-vm1 ansible_host=192.168.56.201
```

### 8. Instalar Galaxy Collections

```bash
# Instalar roles y collections desde requirements.yml
ansible-galaxy install -r requirements.yml

# Verificar instalación
ansible-galaxy collection list
```

---

## 🔧 Configuración de Red desde WSL

### Acceder a VMs de VirtualBox desde WSL

Las VMs configuradas con **Host-Only Network** (192.168.56.x) son accesibles desde WSL.

#### Verificar conectividad:

```bash
# Ping a VM Linux
ping -c 3 192.168.56.101

# Ping a VM Windows
ping -c 3 192.168.56.201

# Si no responde, verificar firewall de Windows host
```

#### Si hay problemas de conectividad:

```powershell
# En PowerShell de Windows (NO en WSL)
# Permitir WSL en el firewall
New-NetFirewallRule -DisplayName "WSL" -Direction Inbound -Action Allow
```

---

## ✅ Verificar Configuración

### 1. Test de Conectividad Ansible

```bash
# Test a VMs Linux
ansible linux_servers -m ping

# Test a VMs Windows
ansible windows_servers -m win_ping

# Listar todos los hosts
ansible-inventory --list
```

### 2. Verificar Sintaxis de Playbooks

```bash
# Verificar router principal
ansible-playbook main_router.yml --syntax-check

# Verificar módulo específico
ansible-playbook playbooks/01_users_management.yml --syntax-check
```

---

## 🎯 Ejecutar el Proyecto desde WSL

### Ejecución Normal

```bash
# Ejecutar todos los módulos
ansible-playbook main_router.yml

# Ejecutar módulo específico
ansible-playbook main_router.yml -e "module=1"

# Dry-run (sin hacer cambios)
ansible-playbook main_router.yml --check

# Verbose (para debugging)
ansible-playbook main_router.yml -v
# Más verbose: -vv, -vvv, -vvvv
```

### Con Tags

```bash
# Solo tareas de info (sin cambios)
ansible-playbook main_router.yml --tags info

# Solo usuarios en Linux
ansible-playbook main_router.yml --tags users,linux
```

---

## 📝 Editar Archivos desde WSL

### Opción 1: Editores de terminal

```bash
# Nano (más fácil para principiantes)
nano playbooks/01_users_management.yml

# Vim (más poderoso)
vim roles/users_linux/defaults/main.yml
```

### Opción 2: VS Code desde WSL (RECOMENDADO)

```bash
# Instalar extensión "Remote - WSL" en VS Code

# Abrir proyecto en VS Code desde WSL
code .

# Abrir archivo específico
code inventory/hosts
```

VS Code automáticamente trabajará en modo WSL y tendrás todas las ventajas.

### Opción 3: Editar desde Windows

Los archivos en `/mnt/c/ernesto_ansible/ansible_oficial/` son los mismos que `C:\ernesto_ansible\ansible_oficial\`.

Puedes editar desde Windows con cualquier editor, pero EJECUTAR desde WSL.

---

## 🔐 Gestión de Ansible Vault desde WSL

```bash
# Ver credenciales encriptadas
ansible-vault view group_vars/all/vault.yml

# Editar credenciales
ansible-vault edit group_vars/all/vault.yml

# Crear nuevo archivo encriptado
ansible-vault create group_vars/all/secrets.yml

# Cambiar contraseña del vault
ansible-vault rekey group_vars/all/vault.yml
```

---

## 💡 Tips y Mejores Prácticas

### 1. Alias útiles para .bashrc

```bash
# Editar .bashrc
nano ~/.bashrc

# Añadir al final:
alias cdansible='cd /mnt/c/ernesto_ansible/ansible_oficial'
alias aplay='ansible-playbook'
alias acheck='ansible-playbook --syntax-check'

# Recargar
source ~/.bashrc
```

Ahora puedes hacer:
```bash
cdansible  # Ir al proyecto
aplay main_router.yml  # Ejecutar playbook
```

### 2. Variable de entorno para editor

```bash
# Añadir a .bashrc
export EDITOR=nano  # o vim, o code

# Para ansible-vault edit
export ANSIBLE_VAULT_EDITOR=nano
```

### 3. Logs de Ansible

```bash
# Ver logs en tiempo real
tail -f ansible.log

# Buscar errores
grep -i error ansible.log

# Limpiar logs
> ansible.log  # Vaciar archivo
```

---

## 🐛 Troubleshooting WSL

### Problema: "command not found: ansible"

```bash
# Reinstalar Ansible
sudo apt update
sudo apt install -y ansible

# Verificar PATH
echo $PATH
which ansible
```

### Problema: No puede alcanzar VMs de VirtualBox

```bash
# Verificar que WSL puede hacer ping al host Windows
ping $(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')

# Verificar ruta a VMs
ip route

# Si falla, reiniciar WSL
# En PowerShell:
wsl --shutdown
# Luego volver a abrir WSL
```

### Problema: Permisos en archivos

```bash
# WSL puede tener problemas con permisos de archivos de Windows
# Solución: copiar proyecto a filesystem de WSL

# Copiar a home de WSL
cp -r /mnt/c/ernesto_ansible/ansible_oficial ~/ansible_oficial
cd ~/ansible_oficial

# Ahora trabaja desde aquí
```

### Problema: Python o pip3 no encontrado

```bash
# Instalar Python
sudo apt install -y python3 python3-pip

# Crear alias si es necesario
echo "alias python=python3" >> ~/.bashrc
echo "alias pip=pip3" >> ~/.bashrc
source ~/.bashrc
```

### Problema: Vault password file no leído correctamente

```bash
# Verificar que no tiene saltos de línea extra
cat .vault_pass.txt | od -c

# Recrear si es necesario
echo -n "tu-contraseña" > .vault_pass.txt
chmod 600 .vault_pass.txt
```

---

## 🔄 Workflow Recomendado

### Desarrollo y Testing:

1. **Editar archivos**: Desde VS Code en modo WSL o desde Windows
2. **Ejecutar desde WSL**: Siempre ejecutar ansible desde WSL
3. **Ver logs**: `tail -f ansible.log` en WSL
4. **Debugging**: Usar `-vv` o `-vvv` para más detalle

### Ejemplo completo:

```bash
# Terminal WSL - Tab 1
cd /mnt/c/ernesto_ansible/ansible_oficial
code .  # Abrir VS Code

# Terminal WSL - Tab 2
cd /mnt/c/ernesto_ansible/ansible_oficial
tail -f ansible.log  # Ver logs

# Terminal WSL - Tab 3
cd /mnt/c/ernesto_ansible/ansible_oficial
# Ejecutar playbooks
ansible-playbook main_router.yml -e "module=1" --check
```

---

## 📊 Comparación: WSL vs PowerShell

| Característica | WSL (Recomendado) | PowerShell Windows |
|----------------|-------------------|-------------------|
| Compatibilidad Ansible | ✅ Excelente | ⚠️ Limitada |
| Rendimiento | ✅ Rápido | ⚠️ Más lento |
| Módulos soportados | ✅ Todos | ⚠️ Algunos fallan |
| Galaxy roles | ✅ Funcionan bien | ⚠️ Problemas ocasionales |
| Python/pip | ✅ Nativo | ⚠️ Configuración compleja |
| SSH/WinRM | ✅ Ambos funcionan | ✅ Ambos funcionan |
| **Recomendación** | ✅ **USAR ESTO** | ❌ Solo si es necesario |

---

## ✅ Verificación Final

Ejecuta estos comandos para verificar que todo está bien:

```bash
# 1. Verificar Ansible
ansible --version

# 2. Verificar pywinrm
pip3 list | grep pywinrm

# 3. Verificar proyecto
cd /mnt/c/ernesto_ansible/ansible_oficial
ls -la main_router.yml

# 4. Verificar sintaxis
ansible-playbook main_router.yml --syntax-check

# 5. Verificar inventario
ansible-inventory --list

# 6. Test de conectividad
ansible all -m ping  # Linux
ansible windows_servers -m win_ping  # Windows

# Si todos pasan ✅ ¡Estás listo!
```

---

## 🎯 Siguiente Paso

Una vez verificado, puedes ejecutar:

```bash
# Dry-run primero (no hace cambios)
ansible-playbook main_router.yml -e "module=5" --check

# Si todo se ve bien, ejecución real
ansible-playbook main_router.yml -e "module=5"
```

---

## 📚 Recursos Adicionales

- [Documentación WSL](https://docs.microsoft.com/en-us/windows/wsl/)
- [Ansible en WSL](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-on-ubuntu)
- [VS Code + WSL](https://code.visualstudio.com/docs/remote/wsl)

---

**💡 RESUMEN: Sí, WSL funciona perfectamente y es la opción RECOMENDADA para ejecutar este proyecto Ansible en Windows.**
