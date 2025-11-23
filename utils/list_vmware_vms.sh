#!/bin/bash
# Script para listar VMs de VMware desde el host
# Uso: ./list_vmware_vms.sh

echo "╔════════════════════════════════════════════════════════════╗"
echo "║   VMs de VMware en tu Host                               ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo

# Detectar sistema operativo
if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "darwin"* ]]; then
    # Linux o Mac
    VMRUN="vmrun"
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
    # Windows (Git Bash o similar)
    VMRUN="/c/Program Files (x86)/VMware/VMware Workstation/vmrun.exe"
else
    echo "❌ Sistema operativo no soportado"
    exit 1
fi

# Verificar si vmrun existe
if ! command -v "$VMRUN" &> /dev/null && [ ! -f "$VMRUN" ]; then
    echo "❌ vmrun no encontrado"
    echo "Asegúrate de que VMware Workstation esté instalado"
    exit 1
fi

echo "📋 Listando VMs registradas en VMware..."
echo

# Listar VMs en ejecución
echo "🟢 VMs EN EJECUCIÓN:"
"$VMRUN" list 2>/dev/null | tail -n +2 || echo "  (ninguna)"
echo

# Buscar archivos .vmx en ubicaciones comunes
echo "📁 VMs REGISTRADAS (archivos .vmx encontrados):"
echo

if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "darwin"* ]]; then
    # Linux/Mac
    find ~/vmware ~/Documents/Virtual\ Machines -name "*.vmx" 2>/dev/null | while read vm; do
        echo "  📦 $(basename "$vm" .vmx)"
        echo "     Path: $vm"
    done
else
    # Windows
    find /c/Users/$USER/Documents/Virtual\ Machines -name "*.vmx" 2>/dev/null | while read vm; do
        echo "  📦 $(basename "$vm" .vmx)"
        echo "     Path: $vm"
    done
fi

echo
echo "════════════════════════════════════════════════════════════"
echo "💡 Tip: Para ver detalles de una VM específica:"
echo "   vmrun list"
echo "   vmrun -T ws getGuestIPAddress \"path/to/vm.vmx\""
echo "════════════════════════════════════════════════════════════"
