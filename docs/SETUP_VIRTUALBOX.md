# 🖥️ Guía de Configuración de VMs en VMware Workstation

Esta guía te ayudará a configurar máquinas virtuales Linux y Windows en VMware Workstation para usar con Ansible.

## 📋 Requisitos Previos

- VMware Workstation Player (gratuito) o Pro instalado
- Al menos 8GB de RAM disponible
- 50GB de espacio en disco
- Imágenes ISO de:
  - Ubuntu Server 22.04 LTS
  - Windows Server 2019/2022 o Windows 10/11

---

## 🐧 Configuración de VM Linux (Ubuntu)

### 1. Crear la VM

#### Especificaciones recomendadas:
```
Nombre: ansible-linux-01
Sistema: Linux - Ubuntu 64-bit
RAM: 2GB (2048 MB)
CPU: 2 cores
Disco: 20GB (single file)
Red 1: NAT (VMnet8)
Red 2: Host-only (VMnet1)
```

### 2. Configuración de Red

VMware crea automáticamente las redes virtuales:

#### VMnet1 (Host-Only) - Para Ansible
```
Subnet: 192.168.137.0/24
Host IP: 192.168.137.1
Uso: Comunicación entre host y VMs
```

#### VMnet8 (NAT) - Para Internet
```
Subnet: 192.168.XXX.0/24 (variable)
Uso: Acceso a internet para las VMs
```

**Verificar configuración:**
1. VMware → **Edit → Virtual Network Editor**
2. (Requiere privilegios de administrador)
3. Verificar que VMnet1 y VMnet8 existen

### 3. Instalar Ubuntu Server

Ver guía completa en: [`QUICKSTART_FIRST_VM.md`](QUICKSTART_FIRST_VM.md)

**Configuración de red durante instalación:**

Interfaz **ens33** (NAT):
```
- Dejar en DHCP
- Para acceso a internet
```

Interfaz **ens34** (Host-only):
```
Método: Manual
Subnet: 192.168.137.0/24
Address: 192.168.137.101
Gateway: (dejar vacío)
DNS: 8.8.8.8
```

### 4. Configuración Post-Instalación

```bash
# SSH a la VM (desde Windows o WSL)
ssh ansible@192.168.137.101

# Actualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar Python (requerido por Ansible)
sudo apt install -y python3 python3-pip

# Configurar sudo sin password
echo "ansible ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/ansible

# Verificar conectividad
ping -c 3 google.com  # Internet (via NAT)
ping -c 3 192.168.137.1  # Host Windows
```

### 5. SSH Keys (Opcional pero recomendado)

```bash
# Desde WSL
ssh-keygen -t rsa -b 4096 -C "ansible@laptop"
ssh-copy-id ansible@192.168.137.101

# Probar
ssh ansible@192.168.137.101  # Sin contraseña
```

---

## 🪟 Configuración de VM Windows

### 1. Crear la VM

#### Especificaciones recomendadas:
```
Nombre: ansible-windows-01
Sistema: Windows 10/11 64-bit
RAM: 4GB (4096 MB)
CPU: 2 cores
Disco: 40GB (single file)
Red 1: NAT (VMnet8)
Red 2: Host-only (VMnet1)
```

### 2. Instalar Windows

1. Montar ISO de Windows
2. Iniciar VM
3. Seguir instalación estándar de Windows
4. Crear usuario Administrador con contraseña conocida

### 3. Configuración de Red

Después de instalar Windows:

**Adaptador 1 (NAT):**
```
- Dejar en DHCP
- Para internet
```

**Adaptador 2 (Host-only):**
1. Abrir **Network Connections** (ncpa.cpl)
2. Identificar adaptador "Ethernet1" o similar (Host-only)
3. Clic derecho → **Properties**
4. **Internet Protocol Version 4 (TCP/IPv4)** → **Properties**
5. Configurar:
   ```
   ○ Use the following IP address:
   IP address: 192.168.137.201
   Subnet mask: 255.255.255.0
   Default gateway: (dejar vacío)
   
   Preferred DNS: 8.8.8.8
   ```
6. **OK** → **OK**

### 4. Configurar WinRM (PowerShell como Administrador)

```powershell
# Descargar script de configuración de Ansible
$url = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
$file = "$env:TEMP\ConfigureRemotingForAnsible.ps1"
(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)

# Ejecutar configuración
powershell.exe -ExecutionPolicy ByPass -File $file -EnableCredSSP -DisableBasicAuth -Verbose

# Verificar WinRM
winrm get winrm/config/service
winrm get winrm/config/winrs

# Verificar listeners
winrm enumerate winrm/config/Listener
```

### 5. Configurar Firewall

```powershell
# Reglas WinRM
netsh advfirewall firewall add rule name="WinRM-HTTP" dir=in localport=5985 protocol=TCP action=allow
netsh advfirewall firewall add rule name="WinRM-HTTPS" dir=in localport=5986 protocol=TCP action=allow

# Desactivar firewall temporalmente para testing (SOLO PARA LAB)
# Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
```

### 6. Instalar Chocolatey

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Verificar
choco --version
```

### 7. Verificar desde Windows Host

```powershell
# Ping
ping 192.168.137.201

# Test WinRM
Test-WSMan -ComputerName 192.168.137.201

# Debería mostrar información del servicio WinRM
```

---

## 🌐 Configuración de Red VMware

### Verificar Virtual Network Editor

1. VMware → **Edit → Virtual Network Editor**
2. Click **Change Settings** (requiere admin)

#### VMnet1 (Host-Only):
```
Type: Host-only
Subnet IP: 192.168.137.0
Subnet mask: 255.255.255.0
✓ Connect a host virtual adapter to this network
✗ Use local DHCP service (deshabilitado)
```

#### VMnet8 (NAT):
```
Type: NAT
Subnet IP: (automático, ej: 192.168.222.0)
Subnet mask: 255.255.255.0
✓ Use local DHCP service
```

### Verificar desde Windows (PowerShell)

```powershell
# Ver adaptadores VMware
ipconfig | Select-String -Pattern "VMware" -Context 0,5

# Deberías ver:
# VMware Virtual Ethernet Adapter for VMnet1
#   IPv4 Address: 192.168.137.1

# VMware Virtual Ethernet Adapter for VMnet8
#   IPv4 Address: 192.168.XXX.1
```

---

## ✅ Verificación de Conectividad

### Desde Windows Host

```powershell
# Ping a VM Linux
ping 192.168.137.101

# Ping a VM Windows
ping 192.168.137.201

# SSH a Linux
ssh ansible@192.168.137.101

# Test WinRM a Windows
Test-WSMan -ComputerName 192.168.137.201
```

### Con Ansible (desde WSL)

```bash
# Instalar pywinrm
pip3 install pywinrm

# Test Linux
ansible linux_servers -m ping

# Test Windows
ansible windows_servers -m win_ping
```

---

## 📊 Tabla de Configuración de VMs

| VM Name | OS | IP Host-Only | IP NAT | Usuario | RAM | Disco |
|---------|----|--------------| -------|---------|-----|-------|
| ansible-linux-01 | Ubuntu 22.04 | 192.168.137.101 | DHCP | ansible | 2GB | 20GB |
| ansible-linux-02 | Ubuntu 22.04 | 192.168.137.102 | DHCP | ansible | 2GB | 20GB |
| ansible-windows-01 | Windows 10 | 192.168.137.201 | DHCP | Administrator | 4GB | 40GB |
| ansible-windows-02 | Windows 10 | 192.168.137.202 | DHCP | Administrator | 4GB | 40GB |

---

## 🔧 Troubleshooting

### Linux: SSH no responde

```bash
# En la VM
sudo systemctl status ssh
sudo systemctl restart ssh
sudo systemctl enable ssh

# Verificar firewall (debería estar inactivo)
sudo ufw status
```

### Windows: WinRM no responde

```powershell
# Verificar servicio
Get-Service winrm
Start-Service winrm

# Recrear listener HTTPS
$cert = New-SelfSignedCertificate -DnsName "ansible-windows-01" -CertStoreLocation Cert:\LocalMachine\My
winrm create winrm/config/Listener?Address=*+Transport=HTTPS "@{Hostname=`"ansible-windows-01`"; CertificateThumbprint=`"$($cert.Thumbprint)`"}"

# Verificar
winrm enumerate winrm/config/Listener
```

### No hay conectividad de red

```bash
# En Linux VM
ip addr show  # Ver todas las IPs
ip route  # Ver rutas

# Reiniciar networking
sudo systemctl restart systemd-networkd
```

```powershell
# En Windows VM
ipconfig /all
route print

# Renovar IP
ipconfig /release
ipconfig /renew
```

### VMnet1 no aparece en Windows

```powershell
# Como Administrador
net stop VMwareHostd
net start VMwareHostd

# Reiniciar servicios de red VMware
net stop "VMware NAT Service"
net stop "VMware DHCP Service"
net start "VMware DHCP Service"
net start "VMware NAT Service"
```

---

## 🚀 Snapshots en VMware

### Crear Snapshot

```
1. VM → Snapshot → Take Snapshot
2. Nombre: "Base Configuration - After Ansible Module 1"
3. Descripción: "Users and firewall configured"
4. ✓ Snapshot VM memory (para restaurar estado exacto)
5. Take Snapshot
```

### Gestionar Snapshots

```
VM → Snapshot → Snapshot Manager
- Ver árbol de snapshots
- Revert to snapshot
- Delete snapshot
```

**Mejores prácticas:**
1. **Base Install** - Después de instalar OS
2. **Ansible Ready** - Después de configurar SSH/WinRM
3. **Before Module X** - Antes de cada módulo importante

---

## 📚 Próximos Pasos

Una vez configuradas las VMs:

1. ✅ Actualizar `inventory/hosts` con las IPs correctas
2. ✅ Configurar credenciales en Ansible Vault
3. ✅ Ejecutar: `ansible-playbook main_router.yml -e "module=1"`
4. ✅ Crear snapshots después de cada módulo exitoso

---

## 🎯 Ventajas de VMware vs VirtualBox

| Característica | Beneficio |
|----------------|-----------|
| **Rendimiento** | 15-20% más rápido en operaciones I/O |
| **Snapshots** | Más rápidos y confiables |
| **Networking** | Configuración más estable |
| **Integración** | Mejor con herramientas profesionales |
| **Clonación** | Mucho más rápida (Pro) |

---

**🎉 ¡VMs listas para automatización con Ansible!**
