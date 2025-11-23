# 🐳 DevContainer Base Images

Base images optimizadas para desarrollo con **Docker-in-Docker**, **Python**, **Node.js**, y herramientas CLI esenciales (AWS CLI, Terraform, GitHub CLI, Task, y más).

## 📦 Imágenes Disponibles

| Imagen | Descripción | Tamaño Aprox. | Casos de Uso |
|--------|-------------|---------------|--------------|
| `devcontainer-base-minimal` | Solo herramientas CLI y Docker | ~800MB | Scripts, CLIs, DevOps |
| `devcontainer-base-python` | Minimal + Python 3.12.3 | ~1.2GB | APIs Python, Data Science |
| `devcontainer-base-node` | Minimal + Node.js 20 | ~1GB | APIs Node, Frontend |
| `devcontainer-base-full` | Python + Node.js | ~1.5GB | Full-stack, Monorepos |

### Herramientas Incluidas en Todas las Imágenes

#### 🐳 Docker & DevOps
- Docker CLI + Docker Compose (con soporte DinD)
- Terraform (latest)
- AWS CLI v2
- GitHub CLI (gh)
- Taskfile (go-task)

#### 🛠️ Utilidades
- jq (JSON processor)
- yq v4 (YAML processor - Go version)
- HTTPie (API testing)
- vim, nano
- Git con autocompletado

#### 🎨 Shell & Prompt
- Zsh con Oh My Zsh
- Starship prompt personalizado
- Aliases útiles pre-configurados
- zsh-autosuggestions y syntax-highlighting

#### 🐍 Python (solo base-python y base-full)
- Python 3.12.3 pre-instalado con pyenv
- pip, pipenv, poetry, virtualenv
- black, flake8, pylint, mypy, pytest
- ipython

#### 📦 Node.js (solo base-node y base-full)
- Node.js 20 pre-instalado con nvm
- npm, yarn, pnpm
- TypeScript, ts-node, nodemon
- ESLint, Prettier, PM2

## 🚀 Inicio Rápido

### 1. Usar en un Proyecto Nuevo

#### Opción A: Con docker-compose (recomendado)

Copia la plantilla completa:
```bash
cd tu-proyecto/
cp -r ~/Workspace/personal/base/.devcontainer .
```

Actualiza `.devcontainer/docker-compose.yml`:
```yaml
services:
  app:
    image: ghcr.io/YOUR_USERNAME/devcontainer-base-full:latest
    volumes:
      - ..:/workspace:cached
      - /var/run/docker.sock:/var/run/docker.sock
    command: sleep infinity
```

#### Opción B: Sin docker-compose (proyectos simples)

Copia la configuración simple:
```bash
cd tu-proyecto/
cp -r ~/Workspace/personal/base/.devcontainer-simple .devcontainer
```

Actualiza `.devcontainer/devcontainer.json` con tu usuario de GitHub.

### 2. Abrir en VS Code

```bash
code tu-proyecto/
```

Luego: `Cmd/Ctrl + Shift + P` → **"Dev Containers: Reopen in Container"**

## 🔧 Construcción Local con Taskfile

### Prerrequisitos

Asegúrate de tener [Task](https://taskfile.dev/) instalado:
```bash
# macOS
brew install go-task

# Linux
sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin

# O si ya está en el devcontainer, ya lo tienes instalado!
```

### Configuración

1. Copia las variables de entorno:
```bash
cp .env.example .env
```

2. Edita `.env` con tus datos:
```bash
export GITHUB_USERNAME="tu-usuario-github"
export GITHUB_TOKEN="ghp_xxxxxxxxxxxxx"  # Solo para publicar en GHCR
```

3. Carga las variables:
```bash
source .env
```

### Comandos Disponibles

#### Build (Paso 1)
```bash
# Ver todas las tareas disponibles
task --list

# Construir todas las imágenes
task build:all

# O construir una específica
task build:minimal
task build:python
task build:node
task build:full

# Quick dev: build + test + list
task dev
```

#### Test
```bash
# Probar que todas las herramientas funcionen
task test

# Listar imágenes construidas
task list
```

## 📤 Publicación en GitHub Container Registry (GHCR)

### Setup Inicial (Paso 3)

1. **Crear repositorio en GitHub con Taskfile**:
   ```bash
   cd ~/Workspace/personal/base
   
   # Inicializar y crear repo en un solo comando
   task setup:init-repo
   ```

   Esto ejecutará:
   - `git init`
   - `git add .`
   - `git commit`
   - `gh repo create` y push

2. **Las imágenes se construyen automáticamente** mediante GitHub Actions en cada push a `main`.

3. **O publicar manualmente con Taskfile**:
   ```bash
   # Asegúrate de tener GITHUB_TOKEN y GITHUB_USERNAME en tu .env
   source .env
   
   # Publicar todas las imágenes (build + tag + push)
   task publish:all
   
   # O paso por paso:
   task publish:login    # Login en GHCR
   task publish:tag      # Tag imágenes
   task publish:push     # Push a GHCR
   
   # Deploy completo (build + test + publish)
   task deploy
   ```

4. **Acceder a las imágenes**:
   ```
   ghcr.io/TU_USUARIO/devcontainer-base-minimal:latest
   ghcr.io/TU_USUARIO/devcontainer-base-python:latest
   ghcr.io/TU_USUARIO/devcontainer-base-node:latest
   ghcr.io/TU_USUARIO/devcontainer-base-full:latest
   ```

## 🎯 Uso en Proyectos (Paso 4)

### Copiar Config a Proyecto con Taskfile

```bash
# Copiar configuración completa (con docker-compose)
task setup:copy-to-project PROJECT=../utem/api

# O copiar configuración simple (sin docker-compose)
task setup:copy-simple PROJECT=../mi-proyecto
```

### Configuración Manual

### Proyecto Full-Stack (Python + Node.js)

```dockerfile
# .devcontainer/Dockerfile
FROM ghcr.io/YOUR_USERNAME/devcontainer-base-full:latest

# Instalar dependencias adicionales específicas del proyecto si es necesario
USER root
RUN apt-get update && apt-get install -y postgresql-client && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER vscode
```

### Proyecto Solo Python

```yaml
# .devcontainer/docker-compose.yml
services:
  app:
    image: ghcr.io/YOUR_USERNAME/devcontainer-base-python:latest
    volumes:
      - ..:/workspace:cached
      - /var/run/docker.sock:/var/run/docker.sock
    command: sleep infinity

  db:
    image: postgres:15
    environment:
      POSTGRES_PASSWORD: dev
```

### Proyecto con Servicios Adicionales

```yaml
# .devcontainer/docker-compose.yml
services:
  app:
    image: ghcr.io/YOUR_USERNAME/devcontainer-base-full:latest
    volumes:
      - ..:/workspace:cached
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - DATABASE_URL=postgresql://postgres:dev@db:5432/mydb
      - REDIS_URL=redis://redis:6379
    depends_on:
      - db
      - redis

  db:
    image: postgres:15
    environment:
      POSTGRES_PASSWORD: dev
    volumes:
      - postgres-data:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine

volumes:
  postgres-data:
```

## 🔄 Actualización de Imágenes

### Actualizar la Imagen Base

1. Modifica `Dockerfile.base-*` o dotfiles
2. Rebuild y publicar:
   ```bash
   # Build localmente
   task build:all
   
   # O deploy completo (build + test + publish)
   task deploy
   
   # O solo commit y GitHub Actions lo hará automáticamente
   git add .
   git commit -m "Update: ..."
   git push
   ```

### Actualizar Proyectos a Nueva Versión

```bash
# En tu proyecto
cd tu-proyecto/.devcontainer

# Opción 1: Usar latest (siempre actualizado)
# Ya configurado por default

# Opción 2: Usar versión específica
# docker-compose.yml
image: ghcr.io/TU_USUARIO/devcontainer-base-full:main-abc123

# Rebuild container
# Cmd/Ctrl + Shift + P → "Dev Containers: Rebuild Container"
```

## 🧹 Utilidades

```bash
# Limpiar imágenes locales
task clean

# Limpiar todas las imágenes (locales + GHCR tagged)
task clean:all

# Listar todas las imágenes
task list

# Ver ayuda
task help
```

## 🎨 Personalización

### Dotfiles Personales

Los dotfiles se copian en el build, pero puedes sobreescribirlos:

```json
// .devcontainer/devcontainer.json
{
  "postCreateCommand": "cp ~/my-custom-dotfiles/.zshrc ~/.zshrc"
}
```

### Cambiar Versiones de Python/Node

```bash
# En el contenedor, cambiar versión de Python
pyenv install 3.11.5
pyenv local 3.11.5

# Cambiar versión de Node.js
nvm install 18
nvm use 18
```

### Agregar Herramientas Personalizadas

```dockerfile
# .devcontainer/Dockerfile
FROM ghcr.io/YOUR_USERNAME/devcontainer-base-full:latest

USER root
RUN apt-get update && apt-get install -y redis-tools && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER vscode
```

## 🔑 Configuración SSH para Git

Las imágenes incluyen soporte para autenticación SSH con servicios Git. Esto es útil para:
- Clonar repositorios privados sin contraseña
- Commits firmados con SSH
- Mejor seguridad que HTTPS

### Setup Rápido

Desde el devcontainer, ejecuta:

```bash
# Ejecutar el script de configuración interactivo
bash /workspace/dotfiles/setup-ssh.sh
```

El script te guiará para:
1. Generar claves SSH (ed25519) para GitHub, GitLab, o Bitbucket
2. Configurar `~/.ssh/config` automáticamente
3. Mostrarte las claves públicas para copiar a tus servicios

### Setup Manual

#### 1. Generar Clave SSH

```bash
# Generar clave para GitHub
ssh-keygen -t ed25519 -C "tu@email.com" -f ~/.ssh/id_ed25519_github

# Generar clave para GitLab
ssh-keygen -t ed25519 -C "tu@email.com" -f ~/.ssh/id_ed25519_gitlab
```

#### 2. Copiar Clave Pública

```bash
# Ver tu clave pública
cat ~/.ssh/id_ed25519_github.pub

# Copiarla al clipboard (si estás en Mac host)
cat ~/.ssh/id_ed25519_github.pub | pbcopy
```

Agrega la clave a:
- **GitHub**: https://github.com/settings/keys
- **GitLab**: https://gitlab.com/-/profile/keys
- **Bitbucket**: https://bitbucket.org/account/settings/ssh-keys/

#### 3. Configurar SSH Config

El archivo `~/.ssh/config` ya está pre-configurado desde el template. Si necesitas ajustarlo:

```bash
# Editar config
vim ~/.ssh/config
```

#### 4. Probar Conexión

```bash
# Probar GitHub
ssh -T git@github.com
# Debe responder: "Hi USERNAME! You've successfully authenticated..."

# Probar GitLab
ssh -T git@gitlab.com

# Ver claves cargadas en el agente
ssh-add -l
```

### Aliases SSH Disponibles

```bash
sshls          # Listar archivos en ~/.ssh/
sshconfig      # Editar ~/.ssh/config
sshtest-gh     # Probar conexión con GitHub
sshtest-gl     # Probar conexión con GitLab
sshtest-bb     # Probar conexión con Bitbucket
sshadd         # Agregar todas las claves al agente
sshkeys        # Listar claves en el agente
```

### Persistencia de Claves

Las claves SSH se almacenan en `~/.ssh/` dentro del contenedor. Para persistirlas:

#### Opción 1: Volume Mount (Recomendado para desarrollo local)

```json
// .devcontainer/devcontainer.json
{
  "mounts": [
    "source=${localEnv:HOME}/.ssh,target=/home/vscode/.ssh,type=bind,consistency=cached"
  ]
}
```

#### Opción 2: Docker Volume (Para CI/CD o múltiples proyectos)

```yaml
# docker-compose.yml
services:
  app:
    volumes:
      - ssh-keys:/home/vscode/.ssh

volumes:
  ssh-keys:
```

#### Opción 3: GitHub Codespaces / Secretos

GitHub Codespaces sincroniza automáticamente tus claves SSH si están configuradas en:
https://github.com/settings/codespaces

### Uso con Git

Una vez configurado SSH, puedes usar URLs SSH:

```bash
# Clonar con SSH
git clone git@github.com:usuario/repo.git

# Cambiar remote de HTTPS a SSH
git remote set-url origin git@github.com:usuario/repo.git

# Commits firmados con SSH (opcional)
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519_github.pub
git config --global commit.gpgsign true
```


```dockerfile
# Extender la imagen
FROM ghcr.io/YOUR_USERNAME/devcontainer-base-full:latest

USER root
RUN curl -fsSL https://deno.land/install.sh | sh
USER vscode
```

## 🐛 Troubleshooting

### Docker-in-Docker no funciona

Verifica que el socket esté montado:
```yaml
volumes:
  - /var/run/docker.sock:/var/run/docker.sock
```

Y que el usuario esté en el grupo docker (ya configurado en la imagen).

### Python/Node no se encuentra

```bash
# Verificar pyenv
pyenv versions
pyenv global 3.12.3

# Verificar nvm
nvm list
nvm use 20
```

### Permisos de archivos

Si tienes problemas de permisos con volúmenes:
```yaml
# docker-compose.yml
user: "${UID:-1000}:${GID:-1000}"
```

## 📁 Estructura del Repositorio

```
personal/base/
├── README.md                      # Este archivo
├── Taskfile.yml                   # Task automation
├── .env.example                   # Variables de entorno template
├── .dockerignore                  # Excluir archivos del build
├── Dockerfile.base-minimal        # Imagen minimal
├── Dockerfile.base-python         # Imagen Python
├── Dockerfile.base-node           # Imagen Node.js
├── Dockerfile.base-full           # Imagen Full-stack
├── dotfiles/                      # Configuraciones
│   ├── .zshrc                     # Config zsh
│   ├── .aliases                   # Aliases útiles
│   ├── .gitconfig.template        # Template git
│   └── starship.toml              # Config Starship
├── .devcontainer/                 # Ejemplo con docker-compose
│   ├── devcontainer.json
│   └── docker-compose.yml
├── .devcontainer-simple/          # Ejemplo sin docker-compose
│   ├── devcontainer.json
│   └── README.md
└── .github/
    └── workflows/
        └── build-images.yml       # CI/CD automatizado
```

## 🤝 Contribuir

Para contribuir mejoras a las imágenes base:

1. Crea un branch
2. Haz tus cambios
3. Prueba localmente:
   ```bash
   task build:all
   task test
   ```
4. Commit y push
5. Las imágenes se actualizarán automáticamente en GHCR

## 📝 Notas

- **Tiempo de inicio**: ~15-20 segundos (vs 5-10 minutos con instalación en `postCreateCommand`)
- **Tamaño total**: Las 4 imágenes comparten capas, ocupan ~2GB en total
- **Compatibilidad**: Funciona en VS Code, puede usarse en IntelliJ con docker-compose standalone
- **Actualizaciones**: GitHub Actions mantiene las imágenes actualizadas automáticamente

## 📄 Licencia

MIT - Usa libremente para proyectos personales y comerciales.

---

**Creado por**: [@luism1](https://github.com/luism1)  
**Última actualización**: Noviembre 2025