#!/bin/bash

echo "🚀 Iniciando despliegue..."

# Generar APP_KEY si no existe
if [ -z "$APP_KEY" ]; then
    php artisan key:generate --force
fi

# Crear base de datos SQLite si no existe
if [ ! -f database/database.sqlite ]; then
    touch database/database.sqlite
fi

# Optimizar Laravel
php artisan optimize:clear
php artisan optimize

# Configurar permisos
chmod -R 775 storage bootstrap/cache
chmod 664 database/database.sqlite

# Ejecutar migraciones
php artisan migrate --force

# Ejecutar seeders si está configurado
if [ "$RUN_SEEDERS" = "true" ]; then
    php artisan db:seed --force
fi

echo "✅ Despliegue completado!"
exec apache2-foreground