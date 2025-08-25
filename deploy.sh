#!/bin/bash

echo "🚀 Iniciando despliegue de Laravel 9 con SQLite..."

# Generar key de aplicación si no existe
if [ -z "$APP_KEY" ]; then
    echo "🔑 Generando APP_KEY..."
    php artisan key:generate --force
else
    echo "✅ APP_KEY ya configurado"
fi

# Crear base de datos SQLite si no existe
if [ ! -f database/database.sqlite ]; then
    echo "🗃️ Creando base de datos SQLite..."
    touch database/database.sqlite
    chmod 664 database/database.sqlite
fi

# Optimizar la aplicación
echo "⚡ Optimizando la aplicación..."
php artisan optimize:clear
php artisan optimize
php artisan view:cache

# Configurar permisos de almacenamiento
echo "📁 Configurando permisos..."
chmod -R 775 storage/
chmod -R 775 bootstrap/cache/
chmod 664 database/database.sqlite

# Ejecutar migraciones con SQLite
echo "🔄 Ejecutando migraciones con SQLite..."
php artisan migrate --force

# Ejecutar seeders si está configurado
if [ "$RUN_SEEDERS" = "true" ]; then
    echo "🌱 Ejecutando seeders..."
    php artisan db:seed --force
fi

# Generar storage link
echo "🔗 Creando enlace de almacenamiento..."
php artisan storage:link --force

echo "✅ Despliegue completado con SQLite!"