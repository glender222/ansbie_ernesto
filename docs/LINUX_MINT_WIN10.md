# 🚀 Guía Rápida - Linux Mint + Windows 10 en VMware

Esta guía está adaptada específicamente para usar **Linux Mint** y **Windows 10** en VMware.

## 🎯 Ventajas de Linux Mint

- ✅ **Más fácil que Ubuntu Server** - Interfaz gráfica incluida
- ✅ **Basado en Ubuntu** - Mismo gestor de paquetes (apt)
- ✅ **100% compatible** con Ansible
- ✅ **Mejor para aprender** - Puedes ver visualmente lo que hace Ansible

---

## 📦 Descargas Necesarias

### Linux Mint 21.3 (Virginia)

🔗 **Descarga**: https://www.linuxmint.com/download.php

**Versión recomendada:**
- **Linux Mint 21.3 Cinnamon** (64-bit)
- Tamaño: ~2.5 GB
- Basado en: Ubuntu 22.04 LTS

**Otras ediciones:**
- **MATE** - Más ligero (recomendado si tienes poca RAM)
- **Xfce** - Muy ligero
- **Cinnamon** - Más bonito (recomendado)

### Windows 10

🔗 **Descarga**: https://www.microsoft.com/es-es/software-download/windows10

**Opción 1: Windows 10 Enterprise Evaluation**
- Duración: 90 días
- Link: https://www.microsoft.com/es-es/evalcenter/download-windows-10-enterprise

**Opción 2: Windows 10 ISO oficial (para instalación limpia)**
- Requiere: Clave de producto (o usar trial de 30 días)

---

## 🖥️ Crear VM Linux Mint en VMware

### Especificaciones Recomendadas

```
Nombre: mint-lab-01
SO: Linux → Ubuntu 64-bit (sí, seleccionar Ubuntu)
RAM: 2GB mínimo, 4GB recomendado
CPU: 2 cores
Disco: 30GB
Red 1: NAT (VMnet8) - Internet
Red 2: Host-Only (VMnet1) - Ansible
```

### Instalación de Linux Mint

1. **Montar ISO** de Linux Mint en VMware
2. **Arrancar VM**
3. **Doble clic en "Install Linux Mint"** en el escritorio
4. Seguir el asistente:
   ```
   Idioma: Español
   Teclado: Spanish
   ✓ Instalar software de terceros
   Tipo de instalación: Borrar disco e instalar
   Zona horaria: Tu zona horaria
   Usuario: mint (o el que quieras)
   Contraseña: ****** (recordarla para Ansible)
   Nombre de equipo: mint-lab-01
   ```
5. **Instalar** y esperar (~10 minutos)
6. **Reiniciar**

### Configuración Post-Instalación

Una vez iniciado Linux Mint:

#### 1. Configurar IP estática para adaptador Host-Only

Abrir **Terminal** (Ctrl+Alt+T):

```bash
# Ver interfaces de red
ip addr

# Deberías ver:
# enp0s3 o ens33 (NAT - DHCP)
# enp0s8 o ens34 (Host-Only - sin IP)

# Configurar IP estática en interfaz Host-Only
# Método gráfico (más fácil):
# 1. Click en ícono de red (bandeja del sistema)
# 2. Network Settings
# 3. Seleccionar interfaz "Wired connection 2" (Host-Only)
# 4. Click en engranaje ⚙️
# 5. Tab "IPv4"
# 6. Method: Manual
# 7. Configurar:
#    Address: 192.168.137.101
#    Netmask: 255.255.255.0
#    Gateway: (dejar vacío)
# 8. Apply
```

#### 2. Actualizar el sistema

```bash
sudo apt update
sudo apt upgrade -y
```

#### 3. Instalar OpenSSH (para Ansible)

```bash
# Instalar SSH server
sudo apt install -y openssh-server

# Verificar que está corriendo
sudo systemctl status ssh
sudo systemctl enable ssh

# Permitir en firewall
sudo ufw allow ssh
sudo ufw enable
```

#### 4. Configurar sudo sin contraseña (para Ansible)

```bash
# Reemplazar "mint" con tu usuario
echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$USER

# Verificar
sudo ls  # No debería pedir contraseña
```

#### 5. Instalar Python (si no está)

```bash
sudo apt install -y python3 python3-pip
python3 --version
```

#### 6. Verificar conectividad

```bash
# Internet (via NAT)
ping -c 3 google.com

# Host Windows (via VMnet1)
ping -c 3 192.168.137.1
```

---

## 🪟 Crear VM Windows 10 en VMware

### Especificaciones Recomendadas

```
Nombre: win10-lab-01
SO: Windows → Windows 10 x64
RAM: 4GB mínimo
CPU: 2 cores
Disco: 50GB
Red 1: NAT (VMnet8) - Internet
Red 2: Host-Only (VMnet1) - Ansible
```

### Instalación de Windows 10

1. **Montar ISO** de Windows 10
2. **Arrancar VM** y seguir instalación estándar
3. Configurar:
   ```
   Usuario: Administrador (o el que quieras)
   Contraseña: ****** (recordarla para Ansible)
   ```

### Configuración Post-Instalación

#### 1. Configurar IP estática (adaptador Host-Only)

```
Panel de Control → Redes e Internet → Conexiones de red
Clic derecho en "Ethernet 1" (o adaptador que NO tenga internet)
→ Propiedades → TCP/IPv4 → Propiedades

○ Usar la siguiente dirección IP:
  IP: 192.168.137.201
  Máscara: 255.255.255.0
  Puerta de enlace: (vacío)
  DNS: 8.8.8.8

OK → OK
```

#### 2. Configurar WinRM para Ansible

**PowerShell como Administrador:**

```powershell
# Descargar script de configuración
$url = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
$file = "$env:TEMP\ConfigureRemotingForAnsible.ps1"
(New-Object System.Net.WebClient).DownloadFile($url, $file)

# Ejecutar
powershell.exe -ExecutionPolicy ByPass -File $file -Verbose

# Verificar
winrm get winrm/config/service
```

#### 3. Configurar Firewall

```powershell
# Permitir WinRM
netsh advfirewall firewall add rule name="WinRM-HTTP" dir=in localport=5985 protocol=TCP action=allow
netsh advfirewall firewall add rule name="WinRM-HTTPS" dir=in localport=5986 protocol=TCP action=allow

# Opcional: Desactivar firewall para testing (SOLO LAB)
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
```

#### 4. Instalar Chocolatey

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

choco --version
```

---

## 📝 Configurar Ansible

### En WSL (tu laptop):

#### 1. Actualizar inventario

**Archivo:** `inventory/hosts`

```ini
[linux_servers]
mint-lab-01 ansible_host=192.168.137.101 ansible_user=mint

[mint_servers]
mint-lab-01

[windows_servers]
win10-lab-01 ansible_host=192.168.137.201

[all_linux:children]
linux_servers
mint_servers

[all_windows:children]
windows_servers
```

#### 2. Actualizar group_vars/linux_servers.yml

Ya está configurado, pero verifica:

```yaml
ansible_python_interpreter: /usr/bin/python3
ansible_become: yes
ansible_become_method: sudo
```

#### 3. Configurar Vault

```bash
# Crear vault
./setup_vault.sh

# Editar credenciales
ansible-vault edit group_vars/all/vault.yml
```

Contenido:

```yaml
---
# Usuario de Linux Mint (el que creaste)
vault_linux_ssh_password: "tu-password-mint"
vault_linux_sudo_password: "tu-password-mint"

# Usuario de Windows 10 (Administrador)
vault_windows_admin_password: "tu-password-windows"
vault_windows_user_password: "tu-password-windows"
```

---

## ✅ Verificar Todo

### Desde WSL:

```bash
cd /mnt/c/ernesto_ansible/ansible_oficial

# 1. Ping desde Windows
ping 192.168.137.101  # Linux Mint
ping 192.168.137.201  # Windows 10

# 2. SSH a Linux Mint
ssh mint@192.168.137.101
# Salir: exit

# 3. Copiar SSH key (opcional)
ssh-copy-id mint@192.168.137.101

# 4. Test Ansible - Linux
ansible mint-lab-01 -m ping

# 5. Test Ansible - Windows
ansible win10-lab-01 -m win_ping

# 6. Ver inventario
ansible-inventory --list
```

---

## 🎯 Ejecutar Primer Módulo

```bash
# Dry-run (sin cambios)
ansible-playbook main_router.yml -e "module=5" --check

# Ejecutar módulo de monitoreo
ansible-playbook main_router.yml -e "module=5"

# Ejecutar módulo de usuarios
ansible-playbook main_router.yml -e "module=1"

# Ejecutar todos
ansible-playbook main_router.yml
```

---

## 📊 Resumen de Configuración

| Componente | IP / Config | Usuario | Password (en vault) |
|------------|-------------|---------|---------------------|
| **Linux Mint VM** | 192.168.137.101 | mint (o tu usuario) | vault_linux_ssh_password |
| **Windows 10 VM** | 192.168.137.201 | Administrador | vault_windows_admin_password |
| **VMware VMnet1** | 192.168.137.1 | - | - |
| **VMware VMnet8** | NAT (DHCP) | - | - |

---

## 💡 Ventajas de usar Linux Mint

1. **Interfaz gráfica** - Puedes ver cambios visualmente
2. **Navegador web** - Consultar documentación en la VM
3. **Editor de texto** - Ver archivos de configuración fácilmente
4. **Más familiar** - Si vienes de Windows
5. **Aprende más** - Ves el antes y después de Ansible

**Desventajas:**
- Usa más RAM que Ubuntu Server (~800MB vs ~300MB)
- Más espacio en disco (~8GB vs ~5GB)

**Conclusión:** Para aprendizaje, ¡Linux Mint es perfecto! 🎓

---

## 🐛 Troubleshooting

### Linux Mint: "Connection refused" en SSH

```bash
# En Linux Mint
sudo systemctl status ssh
sudo systemctl restart ssh

# Verificar firewall
sudo ufw status
sudo ufw allow 22/tcp
```

### Windows 10: WinRM no funciona

```powershell
# Verificar servicio
Get-Service winrm
Start-Service winrm

# Test local
Test-WSMan localhost
```

### Ansible no puede conectar

```bash
# Test manual SSH
ssh -v mint@192.168.137.101

# Test con password (si no tienes SSH key)
ansible mint-lab-01 -m ping --ask-pass

# Ver debug de Ansible
ansible mint-lab-01 -m ping -vvv
```

---

## 🎉 ¡Listo para Automatizar!

Ahora tienes:
- ✅ Linux Mint con SSH y Python
- ✅ Windows 10 con WinRM
- ✅ Ansible configurado
- ✅ Inventario actualizado
- ✅ Credenciales en vault

**Siguiente comando:**
```bash
ansible-playbook main_router.yml
```

**¡Y disfruta viendo cómo Ansible configura tus VMs!** 🚀
