# 🚀 Guía de Inicio Rápido - Primera VM en VMware

Esta guía te lleva desde CERO hasta tener tu primera VM configurada con Ansible usando VMware.

## 🎯 Objetivo

Crear una VM Ubuntu en VMware desde una ISO y luego usar Ansible para configurarla automáticamente.

---

## 📦 Lo que necesitas

### 1. Software (en tu laptop Windows)

- ✅ **VMware Workstation Player** (gratuito) o **VMware Workstation Pro**
- ✅ **WSL (Ubuntu)** - Para ejecutar Ansible
- ✅ **ISO de Ubuntu Server** - Para crear la VM

### 2. Descargar ISO de Ubuntu Server

**Opción recomendada: Ubuntu Server 22.04 LTS**

🔗 **Link de descarga**: https://ubuntu.com/download/server

- Tamaño: ~1.4 GB
- Versión: 22.04.3 LTS (Long Term Support)
- Archivo: `ubuntu-22.04.3-live-server-amd64.iso`

> 💡 **Tip**: Descarga mientras sigues los otros pasos, puede tardar 10-30 minutos.

---

## 🖥️ ¿Dónde se levanta todo?

```
Tu Laptop Windows
│
├── 🐧 WSL (Ubuntu)
│   └── Ansible se ejecuta AQUÍ
│   └── Archivos del proyecto en /mnt/c/ernesto_ansible/
│
└── 📦 VMware Workstation
    └── VM Ubuntu (creada desde ISO)
        └── Ansible la configura remotamente desde WSL
```

**Flujo:**
1. VMware crea la VM desde la ISO (instalación manual básica)
2. La VM queda "de fábrica" con solo SSH instalado
3. Desde WSL ejecutas Ansible
4. Ansible se conecta a la VM y la configura automáticamente

---

## 🚀 Paso a Paso - Tu Primera VM

### PASO 1: Instalar VMware Workstation

#### Opción A: VMware Workstation Player (Gratuito para uso personal)

```
🔗 Descarga: https://www.vmware.com/products/workstation-player/workstation-player-evaluation.html

Características:
- Gratuito para uso no comercial
- Funcionalidad completa para este proyecto
- Recomendado para aprendizaje
```

#### Opción B: VMware Workstation Pro (De pago, 30 días trial)

```
🔗 Descarga: https://www.vmware.com/products/workstation-pro/workstation-pro-evaluation.html

Características adicionales:
- Snapshots múltiples
- Clonación de VMs
- Mejor para entornos profesionales
```

**Instalación:**
1. Descargar instalador
2. Ejecutar como Administrador
3. Seguir el asistente (siguiente, siguiente, instalar)
4. Reiniciar si es solicitado

---

### PASO 2: Configurar Red en VMware

VMware crea automáticamente dos redes virtuales:

#### Redes por defecto:

```
VMnet1 (Host-Only)
├── Subnet: 192.168.137.0/24
├── Host IP: 192.168.137.1
└── Uso: Para que Ansible pueda conectarse

VMnet8 (NAT)
├── Subnet: 192.168.XXX.0/24 (variable)
└── Uso: Para que la VM tenga internet
```

#### Verificar/Configurar redes:

1. Abrir **VMware Workstation**
2. Ir a **Edit → Virtual Network Editor**
3. Si pide privilegios de administrador, aceptar

**Configurar VMnet1 (Host-Only):**
```
Nombre: VMnet1
Type: Host-only
Subnet IP: 192.168.137.0
Subnet mask: 255.255.255.0
✓ Connect a host virtual adapter to this network
✗ Use local DHCP service (desmarcar)
```

**Verificar VMnet8 (NAT):**
```
Nombre: VMnet8
Type: NAT
✓ Use local DHCP service (dejar marcado)
```

4. Click **OK** y **Apply**

---

### PASO 3: Crear VM Ubuntu desde ISO

#### 3.1 Crear la VM

1. **VMware Workstation** → **File → New Virtual Machine**
2. Seleccionar **Custom (advanced)** → **Next**
3. Hardware compatibility: **Workstation 16.x** (o la más reciente) → **Next**

#### 3.2 Seleccionar ISO

```
○ I will install the operating system later
```
→ **Next**

*(Instalaremos manualmente para tener control total)*

#### 3.3 Sistema Operativo

```
Guest operating system: Linux
Version: Ubuntu 64-bit
```
→ **Next**

#### 3.4 Nombre y Ubicación

```
Virtual machine name: ansible-ubuntu-01
Location: C:\VMs\ansible-ubuntu-01
```
→ **Next**

#### 3.5 Procesador

```
Number of processors: 1
Number of cores per processor: 2
```
→ **Next**

#### 3.6 Memoria

```
Memory for this virtual machine: 2048 MB (2 GB)
```
→ **Next**

#### 3.7 Red (IMPORTANTE)

```
Network type: Use bridged networking
```
→ **Next**

*(Lo cambiaremos después a configuración dual)*

#### 3.8 I/O Controller

```
(Dejar por defecto: LSI Logic)
```
→ **Next**

#### 3.9 Disco Virtual

```
Disk type: SCSI (Recommended)
→ Next

○ Create a new virtual disk
→ Next

Maximum disk size: 20 GB
○ Store virtual disk as a single file
→ Next

Disk file: (dejar por defecto)
→ Next
```

#### 3.10 Finalizar

Click **Finish**

---

### PASO 4: Configurar la VM antes de encender

#### 4.1 Añadir la ISO

1. Seleccionar la VM → **Edit virtual machine settings**
2. En **CD/DVD (SATA)**:
   ```
   ✓ Connect at power on
   ● Use ISO image file
   [Browse...] → Seleccionar ubuntu-22.04.3-live-server-amd64.iso
   ```

#### 4.2 Configurar Red Dual (CRÍTICO)

En **Edit virtual machine settings** → **Hardware**:

**Adaptador de Red 1 (para internet):**
```
Network Adapter: NAT
✓ Connect at power on
```

**Añadir Adaptador de Red 2 (para Ansible):**
1. Click **Add** → **Network Adapter** → **Next**
2. Configurar:
   ```
   Network connection: Custom: Specific virtual network
   Seleccionar: VMnet1 (Host-only)
   ✓ Connect at power on
   ```
3. Click **Finish**

Deberías tener **2 Network Adapters**.

4. Click **OK**

---

### PASO 5: Instalar Ubuntu en la VM

#### 5.1 Arrancar VM

1. Seleccionar la VM
2. Click **Power on this virtual machine**
3. La VM arrancará desde la ISO

*(La instalación es exactamente igual que en la otra guía)*

#### 5.2 Instalación de Ubuntu (paso a paso)

**Pantalla 1: Idioma**
```
Select: English
```

**Pantalla 2: Keyboard**
```
Layout: Spanish (o el que uses)
Variant: Spanish
```

**Pantalla 3: Type of install**
```
Select: Ubuntu Server (minimized)
```

**Pantalla 4: Network (MUY IMPORTANTE)**

Deberías ver 2 interfaces:
```
ens33: DHCP (NAT - internet) - IP 192.168.XXX.XXX
ens34: No configurada aún
```

1. Seleccionar **ens34** (el adaptador host-only)
2. Presionar **Enter** para editar
3. Seleccionar **Edit IPv4**
4. Cambiar de **Automatic (DHCP)** a **Manual**
5. Configurar:
   ```
   Subnet: 192.168.137.0/24
   Address: 192.168.137.101
   Gateway: (dejar vacío)
   Name servers: 8.8.8.8
   ```
6. **Save**
7. **Done**

**Pantalla 5: Proxy**
```
(dejar vacío)
Done
```

**Pantalla 6: Mirror**
```
(dejar por defecto)
Done
```

**Pantalla 7: Storage**
```
✓ Use entire disk
✓ Set up this disk as an LVM group
Done
Continue
```

**Pantalla 8: Profile Setup (IMPORTANTE)**
```
Your name: Ansible Admin
Your server's name: ansible-ubuntu-01
Pick a username: ansible
Choose a password: ******** (recordar esta contraseña)
Confirm password: ********
Done
```

**Pantalla 9: SSH Setup (MUY IMPORTANTE)**
```
✓ Install OpenSSH server  ← MARCAR ESTO
(no importar ninguna clave todavía)
Done
```

**Pantalla 10: Featured snaps**
```
(no seleccionar nada)
Done
```

Esperar a que termine la instalación (~5-10 minutos).

Cuando diga **"Reboot Now"**, presionar **Enter**.

#### 5.3 Después del reinicio

Una vez reiniciada, VMware preguntará si desconectar la ISO:
```
[Disconnect] ← Click aquí
```

---

### PASO 6: Configuración Post-Instalación en la VM

Una vez que la VM reinicie, verás el login.

#### 6.1 Hacer login

```
ansible-ubuntu-01 login: ansible
Password: ******** (la que pusiste)
```

#### 6.2 Configurar sudo sin contraseña

```bash
# Añadir ansible a sudoers sin contraseña
echo "ansible ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/ansible

# Verificar
sudo ls  # No debería pedir contraseña
```

#### 6.3 Verificar red

```bash
# Ver IPs
ip addr show

# Deberías ver:
# ens33: inet 192.168.XXX.XXX (NAT - puede variar)
# ens34: inet 192.168.137.101 (Host-only - FIJA)

# Test de internet
ping -c 3 google.com

# Ver gateway
ip route
```

#### 6.4 Test desde Windows

Abre PowerShell o CMD en Windows:

```powershell
# Ping a la VM
ping 192.168.137.101

# Debería responder:
# Reply from 192.168.137.101: bytes=32 time<1ms TTL=64
```

Si funciona, ¡perfecto! La red está configurada.

#### 6.5 Actualizar sistema

```bash
sudo apt update
sudo apt upgrade -y

# Instalar utilidades básicas
sudo apt install -y vim curl wget htop net-tools
```

#### 6.6 Opcional: Configurar SSH con clave

```bash
# En tu WSL (no en la VM)
# Generar clave SSH si no tienes
ssh-keygen -t rsa -b 4096 -C "ansible@laptop"

# Copiar clave a la VM
ssh-copy-id ansible@192.168.137.101

# Probar conexión sin contraseña
ssh ansible@192.168.137.101
# Debería entrar sin pedir contraseña
exit
```

---

### PASO 7: Configurar Ansible en WSL

Ahora desde WSL (tu laptop Windows):

#### 7.1 Navegar al proyecto

```bash
# Abrir WSL
wsl

# Ir al proyecto
cd /mnt/c/ernesto_ansible/ansible_oficial
```

#### 7.2 Editar inventario

```bash
nano inventory/hosts
```

Actualizar para VMware (usar IP 192.168.137.101):

```ini
[linux_servers]
ansible-ubuntu-01 ansible_host=192.168.137.101 ansible_user=ansible

[ubuntu_servers]
ansible-ubuntu-01
```

Guardar (Ctrl+O, Enter, Ctrl+X)

#### 7.3 Configurar Vault (si no lo has hecho)

```bash
# Configurar vault
./setup_vault.sh

# Editar credenciales
ansible-vault edit group_vars/all/vault.yml
```

Añadir:
```yaml
---
vault_linux_ssh_password: "la-contraseña-de-ansible"
vault_linux_sudo_password: "la-contraseña-de-ansible"
vault_windows_admin_password: "cambiar-cuando-tengas-Windows"
```

---

### PASO 8: Probar Conectividad

```bash
# Test con ping module
ansible ansible-ubuntu-01 -m ping

# Deberías ver:
# ansible-ubuntu-01 | SUCCESS => {
#     "changed": false,
#     "ping": "pong"
# }

# Si falla y pide contraseña, usa:
ansible ansible-ubuntu-01 -m ping --ask-pass

# Ver información del sistema
ansible ansible-ubuntu-01 -m setup -a "filter=ansible_distribution*"
```

---

### PASO 9: Ejecutar Primer Módulo de Ansible

#### Dry-run (sin hacer cambios)

```bash
ansible-playbook main_router.yml -e "module=1" --check -v
```

#### Ejecución real

```bash
# Ejecutar módulo 1 (Usuarios)
ansible-playbook main_router.yml -e "module=1"

# Ejecutar módulo 5 (Monitoreo)
ansible-playbook main_router.yml -e "module=5"

# Ejecutar todos los módulos
ansible-playbook main_router.yml
```

---

## 📊 Resumen de IPs para VMware

| Componente | IP / Red | Acceso |
|------------|----------|--------|
| **Tu laptop Windows** | IP de red local | - |
| **WSL Ubuntu** | Interno en Windows | `wsl` |
| **VMware VMnet1** | 192.168.137.1 | Adaptador Host-Only |
| **VMware VMnet8** | 192.168.XXX.1 | Adaptador NAT |
| **VM Ubuntu (ens34)** | 192.168.137.101 | `ssh ansible@192.168.137.101` |
| **VM Ubuntu (ens33)** | 192.168.XXX.XXX | Internet (DHCP) |

---

## 🔄 Snapshots en VMware (Ventaja sobre VirtualBox)

VMware tiene excelente soporte para snapshots:

```
1. VM → Snapshot → Take Snapshot
2. Nombre: "Base Installation - Before Ansible"
3. Descripción: "Clean Ubuntu install with SSH"
4. ✓ Snapshot the virtual machine's memory (opcional)
5. Take Snapshot
```

**Para revertir:**
```
VM → Snapshot → Revert to Snapshot → [nombre]
```

---

## 🎯 Crear Más VMs

### Opción 1: Clonar (VMware Pro solamente)

```
1. Apagar la VM original
2. VM → Manage → Clone
3. Seleccionar snapshot o current state
4. Full Clone
5. Nuevo nombre: ansible-ubuntu-02
6. Finish
```

### Opción 2: Crear nueva (VMware Player y Pro)

Repetir pasos 3-6, pero:
- Nombre: `ansible-ubuntu-02`
- IP: `192.168.137.102`

### Actualizar inventario:

```ini
[linux_servers]
ansible-ubuntu-01 ansible_host=192.168.137.101 ansible_user=ansible
ansible-ubuntu-02 ansible_host=192.168.137.102 ansible_user=ansible
```

---

## 🐛 Troubleshooting VMware

### No puedo hacer ping a la VM

```bash
# En la VM, verificar IP
ip addr show ens34

# Debería mostrar 192.168.137.101

# Verificar ruta
ip route

# Desde Windows, verificar adaptador VMnet1
ipconfig
# Buscar: "VMware Virtual Ethernet Adapter for VMnet1"
# Debería tener IP: 192.168.137.1
```

### VMnet1 no tiene IP en Windows

```powershell
# Ejecutar como Administrador en PowerShell
# Reiniciar servicios VMware
net stop VMwareHostd
net start VMwareHostd

net stop "VMware NAT Service"
net start "VMware NAT Service"
```

### SSH connection refused

```bash
# En la VM
sudo systemctl status ssh
sudo systemctl restart ssh

# Verificar firewall (debería estar deshabilitado por defecto en Ubuntu)
sudo ufw status
```

### Ansible no puede conectar

```bash
# Test manual de SSH desde WSL
ssh ansible@192.168.137.101

# Si falla, verificar:
# 1. Ping funciona
ping 192.168.137.101

# 2. Puerto SSH abierto
nc -zv 192.168.137.101 22

# 3. Llave SSH correcta
ssh-keygen -R 192.168.137.101  # Limpiar clave anterior
ssh-copy-id ansible@192.168.137.101  # Volver a copiar
```

---

## ✅ Checklist de Éxito

- [ ] VMware Workstation instalado
- [ ] Red VMnet1 (Host-only) configurada (192.168.137.0/24)
- [ ] VM Ubuntu creada desde ISO
- [ ] 2 adaptadores de red configurados (NAT + Host-only)
- [ ] SSH habilitado en la VM
- [ ] IP estática configurada (192.168.137.101)
- [ ] Ping funciona desde Windows: `ping 192.168.137.101`
- [ ] SSH funciona desde WSL: `ssh ansible@192.168.137.101`
- [ ] Ansible conecta: `ansible ansible-ubuntu-01 -m ping`
- [ ] Primer módulo ejecutado correctamente

---

## 🎉 Diferencias clave: VMware vs VirtualBox

| Característica | VMware | VirtualBox |
|----------------|--------|------------|
| **Rendimiento** | ✅ Mejor | ⭐ Bueno |
| **Snapshots** | ✅ Excelentes | ⭐ Básicos |
| **Clonación** | ✅ Rápida (Pro) | ⭐ Lenta |
| **Integración Windows** | ✅ Mejor | ⭐ Buena |
| **Costo** | ⚠️ Player gratuito, Pro $$$| ✅ 100% gratuito |
| **Uso profesional** | ✅ Estándar industria | ⭐ Hobbyist |

---

## 🚀 ¡VM Lista para Ansible!

Tu VM está configurada con:
- ✅ Ubuntu Server 22.04 LTS
- ✅ SSH habilitado
- ✅ Usuario `ansible` con sudo sin contraseña
- ✅ Red dual (internet + host-only)
- ✅ IP fija: 192.168.137.101

**Siguiente paso**: 
```bash
ansible-playbook main_router.yml
```

**¡Y observa cómo Ansible configura todo automáticamente!** 🎯
