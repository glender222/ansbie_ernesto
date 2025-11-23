# 🚀 Proyecto Ansible - Linux Automation

> **📖 [LEE ESTO PRIMERO: docs/GUIA_COMPLETA.md](docs/GUIA_COMPLETA.md)**

Automatización completa para gestionar tu VM Linux Mint con Ansible desde WSL.

---

## ⚡ Inicio Ultra-Rápido

```bash
wsl
cd ~/ansible_off/ansbie_ernesto
git pull
ansible-playbook linux_only.yml -e "module=5" --ask-pass --ask-become-pass
```

**Contraseñas:** `123456` y `Enter`

---

## 📚 Documentación

- **[docs/GUIA_COMPLETA.md](docs/GUIA_COMPLETA.md)** ← TODO lo que necesitas

---

## 🎯 Módulos Disponibles

| # | Nombre | Qué hace |
|---|--------|----------|
| 5 | Monitoreo | CPU, RAM, disco (solo lectura) |
| 1 | Usuarios | Crear usuarios, SSH, sudo |
| 2 | Firewall | Configurar ufw |
| 3 | Cron Jobs | Tareas programadas |
| 4 | Software | vim, git, htop, Docker |
| 6 | Storage | Carpetas y discos |

---

## 💻 Comandos Básicos

```bash
# Probar conectividad
ansible linux_servers -m ping --ask-pass --ask-become-pass

# Ejecutar módulo específico
ansible-playbook linux_only.yml -e "module=5" --ask-pass --ask-become-pass

# Ejecutar todos
ansible-playbook linux_only.yml --ask-pass --ask-become-pass

# Ver qué haría sin ejecutar (dry-run)
ansible-playbook linux_only.yml -e "module=1" --ask-pass --ask-become-pass --check
```

---

## 📦 Estructura

```
ansible_oficial/
├── docs/GUIA_COMPLETA.md    ← Guía completa
├── linux_only.yml           ← Playbook principal
├── inventory/hosts          ← IPs de VMs
└── roles/                   ← 6 roles de Linux
    ├── users_linux/
    ├── firewall_linux/
    ├── scheduled_tasks_linux/
    ├── software_linux/
    ├── monitoring_linux/
    └── storage_linux/
```

---

## 🖥️ Tu Configuración

- **Linux Mint**: glender-vm - 192.168.11.137 - Usuario: glender
- **WSL**: ~/ansible_off/ansbie_ernesto/
- **Playbook**: linux_only.yml (solo Linux)

---

## 🔧 Instalación de Dependencias

```bash
sudo apt install -y ansible sshpass python3-pip
ansible-galaxy install -r requirements.yml
```

---

**📖 Para más detalles, lee: [docs/GUIA_COMPLETA.md](docs/GUIA_COMPLETA.md)**
