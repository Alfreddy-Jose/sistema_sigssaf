#!/bin/bash

echo "🚀 Iniciando despliegue..."

# Generar APP_KEY si no existe (solo en producción)
if [ -z "$APP_KEY" ] || [ "$APP_KEY" = "" ]; then
    echo "🔑 Generando APP_KEY..."
    php artisan key:generate --force
fi

# Crear base de datos SQLite si no existe
if [ ! -f database/database.sqlite ]; then
    echo "🗄️ Creando base de datos SQLite..."
    touch database/database.sqlite
fi

# Configurar permisos
echo "🔧 Configurando permisos..."
chmod -R 775 storage bootstrap/cache
chmod 664 database/database.sqlite
chown -R www-data:www-data storage bootstrap/cache database

# Optimizar Laravel
echo "⚡ Optimizando Laravel..."
php artisan optimize:clear
php artisan optimize

# Ejecutar migraciones
echo "🔄 Ejecutando migraciones..."
php artisan migrate --force

# Ejecutar seeders si está configurado
if [ "$RUN_SEEDERS" = "true" ]; then
    echo "🌱 Ejecutando seeders..."
    php artisan db:seed --force
fi

echo "✅ Despliegue completado!"
exec apache2-foreground