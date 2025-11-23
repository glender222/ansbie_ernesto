# 🚀 CÓMO USAR ANSIBLE - Guía Completa

Ya tienes todo configurado. Aquí te explico cómo funciona y cómo usar cada comando.

---

## 📖 ¿Qué es lo que tienes?

### Tu Setup Actual:

```
Tu PC Windows
│
├─ WSL (Ubuntu) ← Desde aquí ejecutas Ansible
│  └─ Proyecto: ~/ansible_off/ansbie_ernesto/
│
└─ VMware ← Aquí corren tus VMs
   ├─ Linux Mint (192.168.11.137)
   └─ Windows 10 (192.168.11.138)
```

**Flujo:**
1. Abres WSL en tu PC Windows
2. Ejecutas comandos de Ansible
3. Ansible se conecta a las VMs por red (SSH/WinRM)
4. Ansible configura las VMs automáticamente

---

## 🎯 Paso 1: Abrir WSL y ir al proyecto

```bash
# Abrir WSL (desde PowerShell o Terminal)
wsl

# Ir al proyecto
cd ~/ansible_off/ansbie_ernesto
```

---

## ✅ Paso 2: Verificar inventario

```bash
# Ver qué VMs tienes configuradas
ansible-inventory --list
```

Deberías ver:
- `glender-vm` (Linux Mint) - 192.168.11.137
- `ansib-win10` (Windows 10) - 192.168.11.138

---

## 🔌 Paso 3: Probar Conectividad

```bash
ansible all -m ping --ask-pass --ask-become-pass
```

**¿Qué hace esto?**
- `ansible all` = Ejecutar en TODAS las VMs
- `-m ping` = Usar el módulo "ping" (test de conexión)
- `--ask-pass` = Pedir contraseña SSH
- `--ask-become-pass` = Pedir contraseña sudo

**Ansible te preguntará:**
1. "SSH password:" → Escribe: `123456` (para Linux)
2. "BECOME password [defaults to SSH password]:" → Presiona `Enter` (usa la misma)

**Resultado esperado:**
```
glender-vm | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
ansib-win10 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

Si ves esto, ¡funciona! ✅

---

## 🎮 Paso 4: Ejecutar Módulos de Ansible

### ¿Qué hace cada módulo?

| Módulo | Nombre | Qué hace | Ejemplo |
|--------|--------|----------|---------|
| 1 | Usuarios | Crea usuarios, configura SSH, sudo | Crear usuario "admin" |
| 2 | Seguridad | Configura firewall, reglas | Abrir puerto 80, 443 |
| 3 | Tareas Programadas | Crea cron jobs (Linux) o tareas programadas (Windows) | Backup diario a las 2am |
| 4 | Software | Instala paquetes, servicios | Instalar Docker, Nginx |
| 5 | Monitoreo | Verifica servicios, recursos | Ver uso de CPU, RAM, disco |
| 6 | Storage | Gestiona discos, directorios | Crear carpetas, verificar espacio |

---

### 🔍 Módulo 5: Monitoreo (Empieza con este - NO hace cambios)

```bash
ansible-playbook main_router.yml -e "module=5" --ask-pass --ask-become-pass
```

**¿Qué hace?**
- Ve qué servicios están corriendo
- Muestra uso de CPU, RAM, disco
- Lista procesos principales
- **NO modifica nada** - solo lee información

**Contraseñas:** (igual que antes)
- SSH password: `123456`
- BECOME password: `Enter` (usa la misma)

**Salida esperada:**
```
PLAY [Módulo 5: Monitoreo de Sistemas] *****

TASK [Ver servicios en Linux]
ok: [glender-vm]

TASK [Uso de CPU y RAM]
ok: [glender-vm]

TASK [Espacio en disco]
ok: [glender-vm]

...más tareas...

PLAY RECAP **********************************
glender-vm    : ok=10  changed=0  unreachable=0  failed=0
ansib-win10   : ok=8   changed=0  unreachable=0  failed=0
```

---

### 👤 Módulo 1: Gestión de Usuarios (SÍ hace cambios)

```bash
ansible-playbook main_router.yml -e "module=1" --ask-pass --ask-become-pass
```

**¿Qué hace?**
- Crea usuarios y grupos
- Configura claves SSH (Linux)
- Configura sudo sin password (Linux)
- Crea usuarios con políticas de contraseña (Windows)

**⚠️ IMPORTANTE:** Este módulo SÍ modifica las VMs.

**Para ver qué hará SIN ejecutarlo:**
```bash
ansible-playbook main_router.yml -e "module=1" --ask-pass --ask-become-pass --check
```

El flag `--check` es un "dry-run" - te muestra qué haría sin hacerlo.

---

### 🔥 Módulo 2: Firewall

```bash
ansible-playbook main_router.yml -e "module=2" --ask-pass --ask-become-pass
```

**¿Qué hace?**
- Configura firewall (ufw en Linux, Windows Firewall en Windows)
- Abre puertos necesarios (SSH, HTTP, HTTPS, WinRM)
- Configura reglas de seguridad

---

### ⚙️ Módulo 3: Tareas Programadas

```bash
ansible-playbook main_router.yml -e "module=3" --ask-pass --ask-become-pass
```

**¿Qué hace?**
- Crea cron jobs en Linux
- Crea Scheduled Tasks en Windows
- Ejemplo: Limpieza de logs, backups automáticos

---

### � Módulo 4: Software

```bash
ansible-playbook main_router.yml -e "module=4" --ask-pass --ask-become-pass
```

**¿Qué hace?**
- Instala paquetes (vim, git, htop, etc.)
- Instala servicios (Docker, Nginx - usando roles de Galaxy)
- Instala software en Windows (Chocolatey)

**⚠️ ATENCIÓN:** Este módulo puede tardar varios minutos.

---

### 💾 Módulo 6: Storage

```bash
ansible-playbook main_router.yml -e "module=6" --ask-pass --ask-become-pass
```

**¿Qué hace?**
- Crea directorios
- Verifica espacio en disco
- Configura permisos
- Soporte básico para LVM (Linux)

---

## 🚀 Ejecutar TODOS los Módulos

```bash
ansible-playbook main_router.yml --ask-pass --ask-become-pass
```

**Esto ejecuta:**
1. Módulo 1 (Usuarios)
2. Módulo 2 (Firewall)
3. Módulo 3 (Tareas Programadas)
4. Módulo 4 (Software)
5. Módulo 5 (Monitoreo)
6. Módulo 6 (Storage)

**Tiempo estimado:** 10-20 minutos (depende de cuánto software instale)

---

## 🎨 Personalizar lo que Ansible hace

### Ver configuración actual:

```bash
# Ver qué usuarios creará
cat roles/users_linux/defaults/main.yml

# Ver qué software instalará
cat roles/software_linux/defaults/main.yml
```

### Cambiar configuración:

```bash
# Editar usuarios que se crearán
nano roles/users_linux/defaults/main.yml

# Editar software a instalar
nano roles/software_linux/defaults/main.yml
```

---

## 📊 Comandos Útiles

### Ver información de las VMs:

```bash
# Ver sistema operativo
ansible all -a "uname -a" --ask-pass --ask-become-pass

# Ver uptime
ansible all -a "uptime" --ask-pass --ask-become-pass

# Ver usuarios
ansible all -a "whoami" --ask-pass

# Ver espacio en disco (Linux)
ansible glender-vm -a "df -h" --ask-pass --ask-become-pass
```

### Ejecutar solo en Linux:

```bash
ansible linux_servers -m ping --ask-pass --ask-become-pass
```

### Ejecutar solo en Windows:

```bash
ansible windows_servers -m win_ping
```

---

## � Troubleshooting

### Error: "SSH password:"  no funciona

```bash
# Probar SSH manual
ssh glender@192.168.11.137
# Si falla, en la VM Linux:
sudo systemctl start ssh
sudo systemctl enable ssh
```

### Error: Windows no responde

```bash
# Reinstalar pywinrm en WSL
pip3 install --upgrade pywinrm
```

En la VM Windows (PowerShell como Admin):
```powershell
winrm quickconfig -q
```

### Error: "ansible: command not found"

```bash
# Instalar Ansible en WSL
sudo apt update
sudo apt install -y ansible python3-pip
pip3 install pywinrm
```

---

## 📋 Resumen de Contraseñas

| Sistema | Usuario | Password | Uso |
|---------|---------|----------|-----|
| **Linux Mint** | glender | 123456 | SSH + sudo |
| **Windows 10** | ansib | Abc123#* | Admin |

---

## 🎯 Flujo de Trabajo Recomendado

### Para Aprender:

```bash
# 1. Probar conectividad
ansible all -m ping --ask-pass --ask-become-pass

# 2. Ejecutar módulo de monitoreo (solo lectura)
ansible-playbook main_router.yml -e "module=5" --ask-pass --ask-become-pass

# 3. Ver qué hará un módulo SIN ejecutarlo
ansible-playbook main_router.yml -e "module=1" --ask-pass --ask-become-pass --check

# 4. Ejecutar módulo de verdad
ansible-playbook main_router.yml -e "module=1" --ask-pass --ask-become-pass

# 5. Crear snapshot en VMware (por si algo sale mal)
# VMware → VM → Snapshot → Take Snapshot

# 6. Ejecutar siguiente módulo
ansible-playbook main_router.yml -e "module=2" --ask-pass --ask-become-pass
```

### Para Producción:

```bash
# Ejecutar todo de una vez
ansible-playbook main_router.yml --ask-pass --ask-become-pass
```

---

## 💡 Tips

1. **Snapshots:** Antes de ejecutar módulos, crea un snapshot en VMware por si algo falla.

2. **--check:** Usa siempre `--check` primero para ver qué hará Ansible.

3. **-v, -vv, -vvv:** Para ver más detalles de lo que hace:
   ```bash
   ansible-playbook main_router.yml -e "module=5" --ask-pass --ask-become-pass -vv
   ```

4. **Logs:** Todo se guarda en `ansible.log`
   ```bash
   tail -f ansible.log
   ```

---

## 🎉 ¡Listo para Usar!

**Comando más simple para empezar:**

```bash
# 1. Abrir WSL
wsl

# 2. Ir al proyecto
cd ~/ansible_off/ansbie_ernesto

# 3. Probar
ansible all -m ping --ask-pass --ask-become-pass

# 4. Ejecutar módulo 5 (monitoreo)
ansible-playbook main_router.yml -e "module=5" --ask-pass --ask-become-pass
```

**Contraseñas:**
- SSH password: `123456`
- BECOME password: `Enter` (usa la misma)

---

## 📚 Documentación Adicional

- [README.md](README.md) - Documentación completa
- [docs/LINUX_MINT_WIN10.md](docs/LINUX_MINT_WIN10.md) - Configuración de VMs
- [CONFIG.md](CONFIG.md) - Tu configuración actual

---

**¿Listo? ¡Ejecuta el primer comando y observa la magia de Ansible!** 🚀
