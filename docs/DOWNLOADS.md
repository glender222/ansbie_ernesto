# 🔗 Enlaces de Descarga - ISOs y Software

## 💿 ISOs para VMs

### Linux (Recomendado para empezar)

#### Linux Mint 21.3 "Virginia" (⭐ MÁS FÁCIL - Recomendado)
- **Descripción**: Linux con interfaz gráfica, basado en Ubuntu
- **Descarga**: https://www.linuxmint.com/download.php
- **Tamaño**: ~2.5 GB
- **Edición recomendada**: Cinnamon (64-bit)
- **💡 Mejor para**: Principiantes absolutos, ver cambios visualmente
- **Ventaja**: Interfaz gráfica + 100% compatible con Ansible

#### Ubuntu Server 22.04 LTS (Avanzado)
- **Descripción**: Linux sin interfaz gráfica (más eficiente)
- **Descarga**: https://ubuntu.com/download/server
- **Tamaño**: ~1.4 GB
- **Versión**: 22.04.3 LTS
- **Archivo**: `ubuntu-22.04.3-live-server-amd64.iso`
- **💡 Mejor para**: Usuarios con experiencia en Linux

#### Ubuntu Server 20.04 LTS (Alternativa)
- **Descarga**: https://releases.ubuntu.com/20.04/
- **Tamaño**: ~1.1 GB
- **Soporte hasta**: 2025
- **💡 Mejor para**: Si necesitas compatibilidad con software antiguo

#### CentOS Stream 9 (Para práctica con RedHat)
- **Descarga**: https://www.centos.org/download/
- **Tamaño**: ~9 GB (DVD) o ~2 GB (Boot ISO + descarga online)
- **💡 Mejor para**: Entornos enterprise, práctica con RHEL

#### Rocky Linux 9 (Alternativa a CentOS)
- **Descarga**: https://rockylinux.org/download
- **Tamaño**: ~2 GB
- **💡 Mejor para**: Reemplazo estable de CentOS

---

### Windows (Para testing completo)

#### Windows 10 Enterprise Evaluation
- **Descarga**: https://www.microsoft.com/es-es/evalcenter/download-windows-10-enterprise
- **Tamaño**: ~5 GB
- **Duración**: 90 días de evaluación
- **Requiere**: Registro con email (gratuito)
- **💡 Mejor para**: Testing de módulos Windows

#### Windows Server 2022 Evaluation
- **Descarga**: https://www.microsoft.com/es-es/evalcenter/download-windows-server-2022
- **Tamaño**: ~5 GB
- **Duración**: 180 días de evaluación
- **💡 Mejor para**: Simulación de entornos enterprise

#### Windows 11 Dev Environment
- **Descarga**: https://developer.microsoft.com/en-us/windows/downloads/virtual-machines/
- **Formato**: Viene pre-configurado para VirtualBox
- **Duración**: 90 días
- **💡 Mejor para**: Desarrollo rápido sin instalación

---

## 🛠️ Software Necesario

### VMware Workstation

**Opción A: VMware Workstation Player (Recomendado para este proyecto)**
- **Descarga**: https://www.vmware.com/products/workstation-player.html
- **Versión recomendada**: 17.x
- **Plataforma**: Windows hosts
- **Tamaño**: ~600 MB
- **Costo**: Gratuito para uso personal/educativo
- **💡 Suficiente para**: Este proyecto completo

**Opción B: VMware Workstation Pro (Trial 30 días)**
- **Descarga**: https://www.vmware.com/products/workstation-pro.html
- **Ventajas adicionales**:
  - Snapshots ilimitados
  - Clonación rápida de VMs
  - Integración con vSphere
- **Precio**: ~$200 USD (después del trial)
- **💡 Recomendado si**: Ya lo tienes o planeas uso profesional

**¿VirtualBox en vez de VMware?**
- VMware es más rápido y estable
- VirtualBox es 100% gratuito
- Ambos funcionan perfectamente con Ansible
- Elige según tu preferencia/presupuesto

### WSL (Windows Subsystem for Linux)
- **Instalación**: Desde PowerShell (Administrador)
  ```powershell
  wsl --install -d Ubuntu-22.04
  ```
- **Alternativa**: Microsoft Store → "Ubuntu 22.04 LTS"
- **Documentación**: https://learn.microsoft.com/en-us/windows/wsl/install

### Ansible (se instala dentro de WSL)
- **Documentación**: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html
- **Comando en Ubuntu**:
  ```bash
  sudo apt update
  sudo apt install -y ansible
  ```

---

## 📊 Comparación de ISOs para Empezar

| Sistema | Dificultad | Instalación | Tamaño ISO | Uso de RAM | Ansible Support | VMware Compatible |
|---------|------------|-------------|------------|------------|-----------------|-------------------|
| **Ubuntu 22.04** | ⭐ Fácil | 15 min | 1.4 GB | 512 MB+ | ✅ Excelente | ✅ Excelente |
| CentOS Stream 9 | ⭐⭐ Media | 20 min | 9 GB | 768 MB+ | ✅ Excelente | ✅ Excelente |
| Rocky Linux 9 | ⭐⭐ Media | 20 min | 2 GB | 768 MB+ | ✅ Excelente | ✅ Excelente |
| Windows 10 | ⭐⭐⭐ Alta | 30 min | 5 GB | 2 GB+ | ✅ Bueno | ✅ Excelente |
| Windows Server | ⭐⭐⭐ Alta | 30 min | 5 GB | 2 GB+ | ✅ Bueno | ✅ Excelente |

---

## 🎯 Plan Recomendado para Empezar

### Fase 1: Una VM Linux (Día 1)
```
Opción A (Más Fácil):
1. Descargar: Linux Mint 21.3 Cinnamon
2. Crear: 1 VM con interfaz gráfica
3. Configurar: SSH y red
4. Probar: Módulos 1-6 (verás los cambios visualmente)

Opción B (Más Eficiente):
1. Descargar: Ubuntu Server 22.04 LTS
2. Crear: 1 VM sin interfaz gráfica
3. Todo por terminal/SSH
4. Probar: Módulos 1-6
```

### Fase 2: Añadir segunda VM Linux (Día 2)
```
1. Clonar la VM existente
2. Cambiar IP y hostname
3. Probar: Ejecutar playbooks en múltiples hosts
```

### Fase 3: Añadir VM Windows (Día 3-4)
```
1. Descargar: Windows 10 Evaluation
2. Crear: 1 VM Windows
3. Configurar: WinRM
4. Probar: Módulos en Windows
```

---

## 💾 Espacio en Disco Necesario

### Mínimo (1 VM Linux):
```
VMware Workstation Player: 600 MB
ISO Ubuntu: 1.4 GB
VM (disco dinámico): ~8 GB inicial
Total: ~10 GB
```

### Recomendado (2 Linux + 1 Windows):
```
VMware Workstation: ~600 MB
ISOs (Ubuntu + Windows): ~6.4 GB
3 VMs:
  - Ubuntu 1: ~8 GB
  - Ubuntu 2: ~8 GB  
  - Windows 1: ~20 GB
Total: ~43 GB
```

### Proyecto completo + software:
```
VMware + ISOs: ~11 GB
VMs: ~40 GB
WSL Ubuntu: ~5 GB
Total: ~56 GB
```

---

## 🚀 Tutorial en Video (Alternativa)

Si prefieres video tutoriales para instalar Ubuntu en VirtualBox:

### YouTube (buscar):
- "Install Ubuntu Server 22.04 VirtualBox"
- "Ubuntu Server Installation Guide 2024"
- "VirtualBox Ubuntu Setup for Ansible"

### Canales recomendados:
- Learn Linux TV
- TechWorld with Nana
- Jay LaCroix (LearnLinuxTV)

---

## 📝 Checklist de Descargas

Antes de empezar, descarga:

- [ ] **VMware Workstation Player** (600 MB) - 10-15 minutos
- [ ] **Ubuntu Server 22.04 ISO** (1.4 GB) - 10-30 minutos
- [ ] *(Opcional)* **Windows 10 Evaluation** (5 GB) - 30-60 minutos

**Mientras descargas**, puedes:
1. Instalar VMware Workstation
2. Configurar WSL
3. Instalar Ansible en WSL
4. Leer la guía de quick start

---

## 🔒 Notas de Seguridad

### ISOs Oficiales
- ✅ **SOLO descarga de sitios oficiales** (enlaces arriba)
- ❌ **NO uses torrents** o sitios de terceros
- ✅ **Verifica checksums** si es posible

### Windows Evaluation
- Las versiones de evaluación son **legales y gratuitas**
- No requieren clave de producto durante instalación
- Expiran después de 90-180 días
- Se pueden reinstalar para seguir practicando

---

## 💡 Tips para Descargas

### Si la descarga es lenta:
1. **Usar un gestor de descargas**: Free Download Manager, IDM
2. **Elegir mirror más cercano**: Especialmente para Ubuntu
3. **Descargar de noche**: Menos congestión de red

### Enlaces directos de Ubuntu mirrors (más rápido):
- **Canadá**: http://ca.archive.ubuntu.com/ubuntu/
- **EE.UU.**: http://us.archive.ubuntu.com/ubuntu/
- **Europa**: http://de.archive.ubuntu.com/ubuntu/

---

## ❓ Preguntas Frecuentes

**P: ¿Necesito ambos, Linux Y Windows?**
R: No. Empieza solo con Linux (Ubuntu). Windows es opcional.

**P: ¿Puedo usar Debian en vez de Ubuntu?**
R: Sí, Ansible funciona igual. Ubuntu es más fácil para principiantes.

**P: ¿Las ISOs son gratuitas?**
R: Sí, Linux es 100% gratuito. Windows tiene versiones de evaluación gratuitas.

**P: ¿Cuánto espacio necesito realmente?**
R: Mínimo 20 GB libres. Recomendado: 50 GB.

**P: ¿Puedo usar VirtualBox en vez de VMware?**
R: Sí, ambos funcionan perfectamente. VMware es más rápido; VirtualBox es gratuito.

**P: ¿VMware Player es suficiente o necesito Pro?**
R: Player es más que suficiente para este proyecto. Pro tiene features extras (clonación rápida, snapshots avanzados).

---

**🎯 Siguiente paso**: Ir a [QUICKSTART_FIRST_VM.md](QUICKSTART_FIRST_VM.md) para crear tu primera VM.
