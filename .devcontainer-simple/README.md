# DevContainer Simple

Esta es una configuración alternativa **sin docker-compose** para proyectos simples que no necesitan servicios adicionales.

## Uso

1. Copia este archivo a `.devcontainer/devcontainer.json` en tu proyecto
2. Actualiza `YOUR_GITHUB_USERNAME` con tu usuario de GitHub
3. Abre el proyecto en VS Code y selecciona "Reopen in Container"

## Diferencias con la configuración con docker-compose

- ✅ Más simple, un solo archivo
- ✅ Suficiente para proyectos que solo necesitan el contenedor principal
- ❌ No soporta servicios adicionales (bases de datos, redis, etc.)

## Cuándo usar esta configuración

- APIs simples sin base de datos
- Scripts y herramientas CLI
- Proyectos de aprendizaje
- Microservicios que se conectan a servicios externos

## Cuándo NO usar esta configuración

- Proyectos con base de datos local
- Proyectos con múltiples servicios (redis, rabbitmq, etc.)
- Proyectos que requieren configuraciones complejas de red
