# Role: users_linux

Este rol gestiona usuarios, grupos y permisos en sistemas Linux.

## Características

- ✅ Crear y gestionar usuarios del sistema
- ✅ Crear y gestionar grupos
- ✅ Configurar claves SSH autorizadas
- ✅ Configurar sudo sin password para grupos específicos
- ✅ Deshabilitar login de root por SSH
- ✅ Eliminar usuarios obsoletos

## Requisitos

- Ansible 2.9+
- Sistema Linux (Ubuntu, CentOS, Debian, RHEL)
- Privilegios de sudo

## Variables

Ver `defaults/main.yml` para todas las variables disponibles.

### Variables principales:

```yaml
linux_users:
  - name: username
    comment: "User Description"
    groups: [sudo, developers]
    shell: /bin/bash
    password: "{{ 'password' | password_hash('sha512') }}"
    state: present

linux_groups:
  - name: groupname
    gid: 3000
    state: present
```

## Ejemplo de uso

```yaml
- hosts: linux_servers
  roles:
    - role: users_linux
      vars:
        linux_users:
          - name: johndoe
            comment: "John Doe"
            groups: [sudo]
            shell: /bin/bash
```

## Tags

- `users`: Todas las tareas de usuarios
- `groups`: Solo tareas de grupos
- `ssh`: Configuración SSH
- `sudo`: Configuración sudo
- `security`: Tareas de seguridad
- `cleanup`: Eliminación de usuarios

## Licencia

MIT
