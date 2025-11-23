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

## Paso 3: Ejecutar configuración automática

```bash
chmod +x quick_setup.sh
./quick_setup.sh
```

Espera a que termine (10-20 segundos).

---

## Paso 4: Probar conectividad

```bash
ansible all -m ping
```

**Deberías ver:**
```
glender-vm | SUCCESS => {"ping": "pong"}
ansib-win10 | SUCCESS => {"ping": "pong"}
```

---

## Paso 5: Ejecutar módulos

### Módulo 5 (Monitoreo - solo lee):
```bash
ansible-playbook main_router.yml -e "module=5"
```

### Módulo 1 (Usuarios - hace cambios):
```bash
ansible-playbook main_router.yml -e "module=1"
```

### Todos los módulos:
```bash
ansible-playbook main_router.yml
```

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
ansible-playbook utils/list_vms.yml
```

### Ver credenciales del vault:
```bash
ansible-vault view group_vars/all/vault.yml
```

### Editar credenciales:
```bash
ansible-vault edit group_vars/all/vault.yml
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

# En la VM Windows (PowerShell como Admin):
winrm quickconfig -q
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

Si quieres hacer todo de una sola vez:

```bash
wsl
cd /mnt/c/ernesto_ansible/ansible_oficial
chmod +x quick_setup.sh && ./quick_setup.sh && ansible all -m ping
```

**O para ejecutar directamente un módulo después de configurar:**

```bash
wsl
cd /mnt/c/ernesto_ansible/ansible_oficial
chmod +x quick_setup.sh && ./quick_setup.sh && ansible-playbook main_router.yml -e "module=5"
```

---

## 📚 Documentación Completa

Si necesitas más detalles:
- [README.md](../README.md) - Documentación completa del proyecto
- [QUICK_START_5MIN.md](QUICK_START_5MIN.md) - Guía detallada de 5 minutos
- [LINUX_MINT_WIN10.md](LINUX_MINT_WIN10.md) - Configuración específica de tus VMs
