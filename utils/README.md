# 🔍 Utilidades del Proyecto

Esta carpeta contiene scripts útiles para gestionar el proyecto Ansible.

## 📋 Scripts Disponibles

### 1. `list_vms.yml` - Listar VMs del Inventario Ansible

**Descripción:** Playbook que muestra todas las VMs configuradas en tu inventario de Ansible.

**Uso:**
```bash
# Listar todas las VMs
ansible-playbook utils/list_vms.yml

# Solo VMs Linux
ansible-playbook utils/list_vms.yml --tags linux

# Solo VMs Windows
ansible-playbook utils/list_vms.yml --tags windows

# Con test de conectividad
ansible-playbook utils/list_vms.yml --tags connectivity
```

**Muestra:**
- ✅ Grupos de inventario
- ✅ IPs configuradas
- ✅ Usuarios configurados
- ✅ Resumen por categoría
- ✅ Test de conectividad

---

### 2. `list_vmware_vms.ps1` - Listar VMs de VMware (Windows)

**Descripción:** Script PowerShell que lista todas las VMs de VMware en tu PC Windows.

**Uso:**
```powershell
# Ejecutar desde PowerShell
.\utils\list_vmware_vms.ps1
```

**Muestra:**
- 🟢 VMs en ejecución
- 📁 VMs registradas (archivos .vmx)
- 📍 Ubicación de cada VM
- 🌐 IP de VMs en ejecución

---

### 3. `list_vmware_vms.sh` - Listar VMs de VMware (Linux/Mac/WSL)

**Descripción:** Script Bash para listar VMs de VMware desde Linux, Mac o WSL.

**Uso:**
```bash
# Desde WSL o Linux
chmod +x utils/list_vmware_vms.sh
./utils/list_vmware_vms.sh
```

**Muestra:**
- 🟢 VMs en ejecución
- 📁 VMs registradas
- 📍 Paths de archivos .vmx

---

## 🎯 Casos de Uso

### Verificar qué VMs tienes configuradas en Ansible:
```bash
ansible-playbook utils/list_vms.yml
```

### Ver todas las VMs de VMware (incluso sin configurar en Ansible):
```powershell
# En Windows
.\utils\list_vmware_vms.ps1

# En WSL
./utils/list_vmware_vms.sh
```

### Verificar conectividad de VMs:
```bash
ansible-playbook utils/list_vms.yml --tags connectivity
```

---

## 💡 Tips

**Ver solo resumen:**
```bash
ansible-playbook utils/list_vms.yml | grep "RESUMEN" -A 10
```

**Guardar lista en archivo:**
```bash
ansible-playbook utils/list_vms.yml > mis_vms.txt
```

**Ver IPs de VMs usando vmrun:**
```powershell
# Windows
vmrun list
vmrun getGuestIPAddress "C:\VMs\mint-vm1\mint-vm1.vmx"
```

---

## 🔧 Troubleshooting

### Error: "vmrun not found"

**Solución:**
- Verificar que VMware Workstation esté instalado
- Agregar VMware al PATH del sistema
- Usar path completo: `"C:\Program Files (x86)\VMware\VMware Workstation\vmrun.exe"`

### Error: "No hosts matched"

**Solución:**
- Verificar que `inventory/hosts` tenga VMs configuradas
- Descomentar las líneas de ejemplo
- Ejecutar: `ansible-inventory --list` para ver el inventario

---

## 📚 Otros Comandos Útiles

```bash
# Ver inventario completo
ansible-inventory --list

# Ver solo hosts de un grupo
ansible-inventory --list | grep -A 5 "linux_servers"

# Ping rápido a todos
ansible all -m ping

# Ver variables de un host
ansible-inventory --host mint-lab-01
```
