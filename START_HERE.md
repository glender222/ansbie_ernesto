# 🚀 INICIO RÁPIDO - Solo Comandos

Ya tienes todo configurado. Solo sigue estos pasos en orden.

---

## Paso 1: Abrir WSL

```bash
wsl
```

---

## Paso 2: Ir al proyecto

```bash
cd /mnt/c/ernesto_ansible/ansible_oficial
```

---

## Paso 3: Probar conectividad

```bash
ansible all -m ping --ask-pass --ask-become-pass
```

**Ansible te pedirá:**
1. SSH password (Linux: `123456`, Windows usa WinRM automáticamente)
2. BECOME password (sudo): `123456`

**Deberías ver:**
```
glender-vm | SUCCESS => {"ping": "pong"}
ansib-win10 | SUCCESS => {"ping": "pong"}
```

---

## Paso 4: Ejecutar módulos

**Todos los comandos te pedirán las contraseñas cuando ejecutes.**

### Módulo 5 (Monitoreo - solo lee):
```bash
ansible-playbook main_router.yml -e "module=5" --ask-pass --ask-become-pass
```

### Módulo 1 (Usuarios - hace cambios):
```bash
ansible-playbook main_router.yml -e "module=1" --ask-pass --ask-become-pass
```

### Todos los módulos:
```bash
ansible-playbook main_router.yml --ask-pass --ask-become-pass
```

**Contraseñas que te pedirá:**
- SSH password: `123456` (para Linux)
- BECOME password (sudo): `123456` (para Linux)
- Windows usa WinRM con las credenciales del inventario

---

## ✅ ¡Listo!

Si algo falla, ve al troubleshooting abajo.

---

## 🔧 Comandos Adicionales Útiles

### Ver inventario:
```bash
ansible-inventory --list
```

### Listar VMs:
```bash
ansible-playbook utils/list_vms.yml --ask-pass --ask-become-pass
```

### Ejecutar comando ad-hoc:
```bash
# Ver uptime
ansible all -a "uptime" --ask-pass --ask-become-pass

# Ver usuarios
ansible all -a "whoami" --ask-pass
```

---

## 🐛 Troubleshooting

### Si falla el ping a Linux:

```bash
# Probar SSH manual
ssh glender@192.168.11.137
# Password: 123456

# Si falla, en la VM Linux ejecutar:
sudo systemctl start ssh
sudo systemctl enable ssh
```

### Si falla el ping a Windows:

```bash
# Reinstalar pywinrm
pip3 install --upgrade pywinrm
```

En la VM Windows (PowerShell como Admin):
```powershell
winrm quickconfig -q
winrm set winrm/config/service/auth '@{Basic="true"}'
```

### Si no encuentra ansible:

```bash
# Instalar Ansible
sudo apt update
sudo apt install -y ansible

# Instalar pywinrm
pip3 install pywinrm
```

---

## 📋 Resumen de Tu Configuración

| Sistema | IP | Usuario | Password |
|---------|-----|---------|----------|
| Linux Mint | 192.168.11.137 | glender | 123456 |
| Windows 10 | 192.168.11.138 | ansib | Abc123#* |

---

## 🎯 Comandos Todo-en-Uno

**Probar y ejecutar todo:**

```bash
wsl
cd /mnt/c/ernesto_ansible/ansible_oficial
ansible all -m ping --ask-pass --ask-become-pass
ansible-playbook main_router.yml -e "module=5" --ask-pass --ask-become-pass
```

**Contraseñas:**
- SSH password: `123456`
- BECOME password (sudo): `123456`

---

## 📚 Documentación Completa

Si necesitas más detalles:
- [README.md](../README.md) - Documentación completa del proyecto
- [QUICK_START_5MIN.md](QUICK_START_5MIN.md) - Guía detallada de 5 minutos
- [LINUX_MINT_WIN10.md](LINUX_MINT_WIN10.md) - Configuración específica de tus VMs
