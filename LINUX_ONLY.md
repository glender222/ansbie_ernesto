# 🐧 LINUX ONLY - Guía Rápida

Ya tienes todo configurado para Linux. Aquí los comandos que funcionan SIN problemas.

---

## 🎯 Comando Principal

```bash
# En WSL
cd ~/ansible_off/ansbie_ernesto

# Ejecutar playbook SOLO de Linux
ansible-playbook linux_only.yml -e "module=5" --ask-pass --ask-become-pass
```

**Contraseñas:**
- SSH password: `123456`
- BECOME password: `Enter`

---

## 📋 Módulos Disponibles

| Módulo | Comando | Qué hace |
|--------|---------|----------|
| **5** | `-e "module=5"` | Monitoreo (solo lectura - RECOMENDADO PRIMERO) |
| **1** | `-e "module=1"` | Gestión de usuarios |
| **2** | `-e "module=2"` | Firewall |
| **3** | `-e "module=3"` | Tareas programadas (cron) |
| **4** | `-e "module=4"` | Software (vim, git, htop, etc.) |
| **6** | `-e "module=6"` | Storage (directorios, discos) |
| **TODOS** | *(sin -e)* | Ejecuta todos los módulos |

---

## 🚀 Ejemplos de Uso

### Módulo 5: Monitoreo (Seguro - solo lee)
```bash
ansible-playbook linux_only.yml -e "module=5" --ask-pass --ask-become-pass
```

### Módulo 1: Usuarios
```bash
ansible-playbook linux_only.yml -e "module=1" --ask-pass --ask-become-pass
```

### Todos los módulos
```bash
ansible-playbook linux_only.yml --ask-pass --ask-become-pass
```

### Dry-run (ver qué haría sin hacerlo)
```bash
ansible-playbook linux_only.yml -e "module=1" --ask-pass --ask-become-pass --check
```

---

## ✅ Comandos de Verificación

```bash
# Ping a Linux
ansible linux_servers -m ping --ask-pass --ask-become-pass

# Ver uptime
ansible linux_servers -a "uptime" --ask-pass

# Ver espacio en disco
ansible linux_servers -a "df -h" --ask-pass --ask-become-pass

# Ver usuarios
ansible linux_servers -a "cat /etc/passwd | tail -5" --ask-pass --ask-become-pass
```

---

## 💾 Solo Linux

Este playbook (`linux_only.yml`) **solo ejecuta roles de Linux**:
- ✅ NO requiere módulos de Windows
- ✅ NO da errores de `ansible.windows.*`
- ✅ Funciona aunque Windows esté configurado mal
- ✅ Más rápido (no parsea roles de Windows)

---

## 🎉 ¡Listo para Usar!

```bash
# Comando completo más simple
wsl
cd ~/ansible_off/ansbie_ernesto
git pull
ansible-playbook linux_only.yml -e "module=5" --ask-pass --ask-become-pass
```

**Contraseñas: `123456` y `Enter`** 🚀
