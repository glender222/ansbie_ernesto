# 🚀 GUÍA COMPLETA - Proyecto Ansible Linux

**Todo lo que necesitas para ejecutar Ansible en tu Linux Mint VM**

---

## 📋 ¿Qué tienes?

```
Tu PC Windows
├─ WSL (Ubuntu) ← Desde aquí ejecutas Ansible
│  └─ ~/ansible_off/ansbie_ernesto/
└─ VMware
   └─ Linux Mint (192.168.11.137)
```

**Tu configuración:**
- Linux Mint: `glender-vm` - IP: 192.168.11.137 - Usuario: `glender` - Password: `123456`

---

## ⚡ INICIO RÁPIDO (3 pasos)

### 1. Abrir WSL
```bash
wsl
```

### 2. Ir al proyecto
```bash
cd ~/ansible_off/ansbie_ernesto
git pull
```

### 3. Ejecutar módulo de monitoreo
```bash
ansible-playbook linux_only.yml -e "module=5" --ask-pass --ask-become-pass
```

**Contraseñas:**
- SSH password: `123456`
- BECOME password: `Enter`

**¡Listo! Ya está corriendo Ansible.** ✅

---

## 🎯 Los 6 Módulos

| # | Nombre | Comando | Qué hace |
|---|--------|---------|----------|
| 5 | **Monitoreo** | `-e "module=5"` | Ve uso de CPU, RAM, disco - **NO modifica nada** |
| 1 | **Usuarios** | `-e "module=1"` | Crea usuarios, grupos, configura SSH |
| 2 | **Firewall** | `-e "module=2"` | Configura firewall (ufw) |
| 3 | **Cron Jobs** | `-e "module=3"` | Tareas programadas (backups, limpiezas) |
| 4 | **Software** | `-e "module=4"` | Instala vim, git, htop, Docker, Nginx |
| 6 | **Storage** | `-e "module=6"` | Gestiona carpetas y discos |

---

## 💻 Comandos Principales

### Ejecutar un módulo específico:
```bash
ansible-playbook linux_only.yml -e "module=5" --ask-pass --ask-become-pass
```

### Ejecutar TODOS los módulos:
```bash
ansible-playbook linux_only.yml --ask-pass --ask-become-pass
```

### Ver qué haría sin ejecutarlo (dry-run):
```bash
ansible-playbook linux_only.yml -e "module=1" --ask-pass --ask-become-pass --check
```

---

## 🔍 Comandos de Verificación

```bash
# Ping a la VM
ansible linux_servers -m ping --ask-pass --ask-become-pass

# Ver uptime
ansible linux_servers -a "uptime" --ask-pass

# Ver espacio en disco
ansible linux_servers -a "df -h" --ask-pass --ask-become-pass

# Ver usuarios del sistema
ansible linux_servers -a "cat /etc/passwd | tail -10" --ask-pass --ask-become-pass

# Ver servicios corriendo
ansible linux_servers -a "systemctl list-units --type=service --state=running" --ask-pass --ask-become-pass
```

---

## 🎨 Personalizar Configuración

### Ver qué hará cada módulo:

```bash
# Ver usuarios que creará
cat roles/users_linux/defaults/main.yml

# Ver software que instalará
cat roles/software_linux/defaults/main.yml

# Ver reglas de firewall
cat roles/firewall_linux/defaults/main.yml

# Ver tareas programadas
cat roles/scheduled_tasks_linux/defaults/main.yml
```

### Cambiar configuración:

```bash
# Editar usuarios a crear
nano roles/users_linux/defaults/main.yml

# Editar paquetes a instalar
nano roles/software_linux/defaults/main.yml
```

**Después de editar, ejecuta el módulo correspondiente.**

---

## 📚 Estructura del Proyecto

```
ansible_oficial/
├── linux_only.yml          ← Playbook principal (solo Linux)
├── inventory/hosts         ← IPs de tus VMs
├── roles/                  ← 6 roles de Linux
│   ├── users_linux/
│   ├── firewall_linux/
│   ├── scheduled_tasks_linux/
│   ├── software_linux/
│   ├── monitoring_linux/
│   └── storage_linux/
└── group_vars/
    └── linux_servers.yml   ← Variables de Linux
```

---

## 🛠️ Instalación de Dependencias

### En WSL (si es primera vez):

```bash
# Actualizar sistema
sudo apt update

# Instalar Ansible
sudo apt install -y ansible sshpass python3-pip

# Instalar roles de Galaxy
ansible-galaxy install -r requirements.yml
```

---

## 🔧 Troubleshooting

### Error: "to use the 'ssh' connection type... install sshpass"
```bash
sudo apt install -y sshpass
```

### Error: "Permission denied"
```bash
# Verificar contraseña SSH en la VM
ssh glender@192.168.11.137
# Password: 123456

# Si falla, en la VM ejecutar:
sudo systemctl start ssh
sudo systemctl enable ssh
```

### Error: "ansible: command not found"
```bash
sudo apt install -y ansible
```

### Error: Módulo no funciona como esperaba
```bash
# Ver logs detallados
ansible-playbook linux_only.yml -e "module=5" --ask-pass --ask-become-pass -vvv

# Ejecutar en dry-run primero
ansible-playbook linux_only.yml -e "module=1" --ask-pass --ask-become-pass --check
```

---

## 🎓 Ejemplos Completos

### Ejemplo 1: Monitorear la VM (seguro)
```bash
wsl
cd ~/ansible_off/ansbie_ernesto
ansible-playbook linux_only.yml -e "module=5" --ask-pass --ask-become-pass
# SSH password: 123456
# BECOME password: Enter
```

### Ejemplo 2: Instalar software
```bash
# Primero ver qué instalará (dry-run)
ansible-playbook linux_only.yml -e "module=4" --ask-pass --ask-become-pass --check

# Si todo se ve bien, ejecutar
ansible-playbook linux_only.yml -e "module=4" --ask-pass --ask-become-pass
```

### Ejemplo 3: Configurar firewall
```bash
# Ver reglas actuales
cat roles/firewall_linux/defaults/main.yml

# Ejecutar
ansible-playbook linux_only.yml -e "module=2" --ask-pass --ask-become-pass
```

### Ejemplo 4: Crear usuarios
```bash
# Editar usuarios a crear
nano roles/users_linux/defaults/main.yml

# Ejecutar
ansible-playbook linux_only.yml -e "module=1" --ask-pass --ask-become-pass
```

---

## 📊 Flujo de Trabajo Recomendado

### Para Aprender:
1. **Ping** - Verificar conectividad
   ```bash
   ansible linux_servers -m ping --ask-pass --ask-become-pass
   ```

2. **Módulo 5** - Monitoreo (solo lectura)
   ```bash
   ansible-playbook linux_only.yml -e "module=5" --ask-pass --ask-become-pass
   ```

3. **Dry-run** - Ver qué hará un módulo
   ```bash
   ansible-playbook linux_only.yml -e "module=1" --ask-pass --ask-become-pass --check
   ```

4. **Snapshot** - En VMware, crear snapshot antes de cambios importantes

5. **Ejecutar** - Módulo real
   ```bash
   ansible-playbook linux_only.yml -e "module=1" --ask-pass --ask-become-pass
   ```

### Para Producción:
```bash
# Ejecutar todos los módulos de una vez
ansible-playbook linux_only.yml --ask-pass --ask-become-pass
```

---

## 💡 Tips y Consejos

1. **Snapshots**: Crea snapshots en VMware antes de cambios importantes
   - VMware → VM → Snapshot → Take Snapshot

2. **Logs**: Todo se guarda en `ansible.log`
   ```bash
   tail -f ansible.log
   ```

3. **Verbosidad**: Usa `-v`, `-vv` o `-vvv` para más detalles
   ```bash
   ansible-playbook linux_only.yml -e "module=5" --ask-pass --ask-become-pass -vv
   ```

4. **Tags**: Ejecuta solo ciertas tareas
   ```bash
   ansible-playbook linux_only.yml --tags users --ask-pass --ask-become-pass
   ```

5. **Limit**: Ejecuta solo en ciertos hosts
   ```bash
   ansible-playbook linux_only.yml --limit glender-vm --ask-pass --ask-become-pass
   ```

---

## 🔐 Seguridad

### Contraseñas actuales:
- Linux Mint SSH: `123456`
- Linux Mint sudo: `123456` (misma)

### Para cambiar contraseñas:
```bash
# En la VM Linux Mint
passwd
sudo passwd root
```

### SSH sin contraseña (opcional):
```bash
# En WSL, generar clave
ssh-keygen -t rsa

# Copiar a la VM
ssh-copy-id glender@192.168.11.137

# Ahora puedes ejecutar sin --ask-pass
ansible-playbook linux_only.yml -e "module=5" --ask-become-pass
```

---

## 📞 Comandos de Una Línea

### Todo en un comando (desde Windows):
```bash
wsl bash -c "cd ~/ansible_off/ansbie_ernesto && git pull && ansible-playbook linux_only.yml -e 'module=5' --ask-pass --ask-become-pass"
```

### Ping rápido:
```bash
wsl bash -c "cd ~/ansible_off/ansbie_ernesto && ansible linux_servers -m ping --ask-pass --ask-become-pass"
```

---

## 📖 Más Información

- **README.md** - Documentación completa del proyecto
- **LINUX_ONLY.md** - Guía rápida solo para Linux
- **CONFIG.md** - Tu configuración actual
- Cada rol tiene su propio `README.md` en `roles/*/README.md`

---

## 🎉 Resumen Ultra-Rápido

```bash
# 1. Abrir WSL
wsl

# 2. Ir al proyecto
cd ~/ansible_off/ansbie_ernesto
git pull

# 3. Ejecutar (monitoreo)
ansible-playbook linux_only.yml -e "module=5" --ask-pass --ask-become-pass

# Contraseñas: 123456 y Enter
```

**¡Eso es TODO lo que necesitas!** 🚀

---

*Última actualización: Noviembre 2024*
