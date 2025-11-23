# Guía de Configuración de VMs en VirtualBox

Esta guía te ayudará a configurar máquinas virtuales Linux y Windows en VirtualBox para usar con Ansible.

## 📋 Requisitos Previos

- VirtualBox 6.0 o superior instalado
- Al menos 8GB de RAM disponible
- 50GB de espacio en disco
- Imágenes ISO de:
  - Ubuntu Server 22.04 LTS
  - Windows Server 2019/2022 o Windows 10/11

## 🐧 Configuración de VM Linux (Ubuntu)

### 1. Crear la VM

1. **Crear nueva VM** en VirtualBox:
   - Nombre: `ansible-linux-01`
   - Tipo: Linux
   - Versión: Ubuntu (64-bit)
   - RAM: 2GB mínimo
   - Disco: 20GB

2. **Configuración de Red**:
   - Adaptador 1: NAT (para internet)
   - Adaptador 2: Host-only Adapter (para Ansible)
     - Nombre: vboxnet0 (Windows: VirtualBox Host-Only Ethernet Adapter)

### 2. Instalar Ubuntu Server

1. Montar ISO de Ubuntu Server
2. Durante instalación:
   - Instalar OpenSSH Server ✅
   - Crear usuario: `ansible` con password conocido
   - Configurar IP estática en la interfaz host-only

### 3. Configuración Post-Instalación

```bash
# SSH a la VM (desde tu laptop)
ssh ansible@192.168.56.101

# Actualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar Python (requerido por Ansible)
sudo apt install -y python3 python3-pip

# Configurar sudo sin password para ansible
echo "ansible ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/ansible

# Configurar SSH con clave pública (opcional pero recomendado)
# En tu laptop:
ssh-copy-id ansible@192.168.56.101
```

### 4. Configurar IP Estática

Editar `/etc/netplan/00-installer-config.yaml`:

```yaml
network:
  version: 2
  ethernets:
    enp0s3:  # Adaptador NAT
      dhcp4: true
    enp0s8:  # Adaptador Host-only
      addresses:
        - 192.168.56.101/24
      dhcp4: false
```

Aplicar cambios:
```bash
sudo netplan apply
```

## 🪟 Configuración de VM Windows

### 1. Crear la VM

1. **Crear nueva VM** en VirtualBox:
   - Nombre: `ansible-windows-01`
   - Tipo: Windows
   - Versión: Windows 10/11 (64-bit)
   - RAM: 4GB mínimo
   - Disco: 40GB

2. **Configuración de Red**:
   - Adaptador 1: NAT
   - Adaptador 2: Host-only Adapter (vboxnet0)

### 2. Instalar Windows

1. Montar ISO de Windows
2. Completar instalación estándar
3. Configurar usuario Administrador con contraseña conocida

### 3. Configuración Post-Instalación (PowerShell como Administrador)

```powershell
# Descargar script de configuración WinRM de Ansible
Invoke-WebRequest -Uri https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1 -OutFile ConfigureRemotingForAnsible.ps1

# Ejecutar configuración
.\ConfigureRemotingForAnsible.ps1 -EnableCredSSP -DisableBasicAuth -Verbose

# Verificar configuración WinRM
winrm get winrm/config/service
winrm get winrm/config/winrs

# Configurar firewall para WinRM
netsh advfirewall firewall add rule name="WinRM-HTTP" dir=in localport=5985 protocol=TCP action=allow
netsh advfirewall firewall add rule name="WinRM-HTTPS" dir=in localport=5986 protocol=TCP action=allow

# Habilitar ejecución de scripts
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force
```

### 4. Configurar IP Estática

```powershell
# Identificar adaptador Host-only
Get-NetAdapter

# Configurar IP (cambia "Ethernet 2" por el nombre de tu adaptador host-only)
New-NetIPAddress -InterfaceAlias "Ethernet 2" -IPAddress 192.168.56.201 -PrefixLength 24
```

### 5. Instalar Chocolatey (Gestor de Paquetes)

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Verificar instalación
choco --version
```

## 🌐 Configuración de Red Host-Only en VirtualBox

### En Windows (Host)

1. Abrir VirtualBox → **Archivo** → **Administrador de red de host**
2. Crear/Verificar adaptador:
   - Nombre: VirtualBox Host-Only Ethernet Adapter
   - IPv4: 192.168.56.1
   - Máscara: 255.255.255.0
   - DHCP: Deshabilitado

### En Linux/Mac (Host)

```bash
# Listar adaptadores
VBoxManage list hostonlyifs

# Crear si no existe
VBoxManage hostonlyif create

# Configurar
VBoxManage hostonlyif ipconfig vboxnet0 --ip 192.168.56.1 --netmask 255.255.255.0
```

## ✅ Verificación de Conectividad

### Desde tu laptop (host)

```bash
# Ping a VM Linux
ping 192.168.56.101

# Ping a VM Windows
ping 192.168.56.201

# SSH a Linux
ssh ansible@192.168.56.101

# Test WinRM a Windows (desde PowerShell)
Test-WSMan -ComputerName 192.168.56.201
```

### Con Ansible

```bash
# Instalar pywinrm (para Windows)
pip install pywinrm

# Test de conectividad Linux
ansible linux_servers -m ping

# Test de conectividad Windows
ansible windows_servers -m win_ping
```

## 📊 Tabla de Configuración de VMs

| VM Name | OS | IP | Usuario | RAM | Disco | Adaptador 1 | Adaptador 2 |
|---------|----|----|---------|-----|-------|-------------|-------------|
| ansible-linux-01 | Ubuntu 22.04 | 192.168.56.101 | ansible | 2GB | 20GB | NAT | Host-only |
| ansible-linux-02 | Ubuntu 22.04 | 192.168.56.102 | ansible | 2GB | 20GB | NAT | Host-only |
| ansible-windows-01 | Windows 10 | 192.168.56.201 | Administrator | 4GB | 40GB | NAT | Host-only |
| ansible-windows-02 | Windows 10 | 192.168.56.202 | Administrator | 4GB | 40GB | NAT | Host-only |

## 🔧 Troubleshooting

### Linux: SSH no responde

```bash
# En la VM
sudo systemctl status ssh
sudo systemctl restart ssh
sudo ufw allow ssh  # Si firewall está activo
```

### Windows: WinRM no responde

```powershell
# Verificar servicio
Get-Service winrm
Start-Service winrm

# Ver listeners
winrm enumerate winrm/config/Listener

# Recrear listener HTTPS si es necesario
winrm delete winrm/config/Listener?Address=*+Transport=HTTPS
New-SelfSignedCertificate -DnsName "ansible-windows-01" -CertStoreLocation Cert:\LocalMachine\My
# Nota el Thumbprint
winrm create winrm/config/Listener?Address=*+Transport=HTTPS '@{Hostname="ansible-windows-01"; CertificateThumbprint="THUMBPRINT_AQUI"}'
```

### No hay conectividad de red

1. Verificar que ambos adaptadores estén conectados en VirtualBox
2. Verificar configuración de IP estática
3. Desde la VM hacer ping al host: `ping 192.168.56.1`
4. Deshabilitar firewall temporalmente para diagnosticar

## 📚 Próximos Pasos

Una vez configuradas las VMs:

1. Actualizar `inventory/hosts` con las IPs correctas
2. Configurar credenciales en Ansible Vault
3. Ejecutar playbook de verificación: `ansible-playbook playbooks/site.yml`
4. Proceder con los módulos específicos

## 🎯 Snapshots Recomendados

Crear snapshots en estos puntos:

1. **"Base Install"** - Después de instalar el OS
2. **"Ansible Ready"** - Después de toda la configuración
3. **"Before Module X"** - Antes de aplicar cada módulo

Esto permite revertir cambios fácilmente durante pruebas.
