# Role: users_windows

Este rol gestiona usuarios, grupos y permisos en sistemas Windows.

## Características

- ✅ Crear y gestionar usuarios locales de Windows
- ✅ Crear y gestionar grupos locales
- ✅ Configurar políticas de contraseñas
- ✅ Habilitar/configurar Remote Desktop (RDP)
- ✅ Gestionar membresías de grupos
- ✅ Eliminar usuarios y perfiles obsoletos

## Requisitos

- Ansible 2.9+
- Windows 10/11 o Windows Server 2016+
- WinRM configurado
- Módulos de Ansible:
  - ansible.windows
  - community.windows

## Variables

Ver `defaults/main.yml` para todas las variables disponibles.

### Variables principales:

```yaml
windows_users:
  - name: username
    fullname: "Full Name"
    description: "User Description"
    password: "SecurePassword123!"
    groups: [Administrators]
    state: present
    password_never_expires: true

windows_groups:
  - name: groupname
    description: "Group Description"
    state: present
```

## Ejemplo de uso

```yaml
- hosts: windows_servers
  roles:
    - role: users_windows
      vars:
        windows_users:
          - name: johndoe
            fullname: "John Doe"
            groups: [Administrators]
            password: "{{ vault_windows_password }}"
```

## Tags

- `users`: Todas las tareas de usuarios
- `groups`: Solo tareas de grupos
- `security`: Configuración de seguridad
- `password_policy`: Políticas de contraseñas
- `remote_desktop`: Configuración de RDP
- `firewall`: Reglas de firewall
- `cleanup`: Eliminación de usuarios
- `info`: Información de usuarios

## Notas de seguridad

- Las contraseñas deben estar encriptadas con Ansible Vault
- Se recomienda habilitar la complejidad de contraseñas
- Configurar políticas de expiración apropiadas
- Limitar acceso de Remote Desktop solo a usuarios necesarios

## Licencia

MIT
