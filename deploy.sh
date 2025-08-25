#!/bin/bash

# Script de despliegue para Laravel 9 con migraciones y seeders

echo "🚀 Iniciando despliegue de Laravel 9..."

# Verificar si las variables de base de datos están configuradas
if [ -z "$DB_HOST" ] || [ -z "$DB_DATABASE" ] || [ -z "$DB_USERNAME" ]; then
    echo "⚠️  Advertencia: Variables de base de datos no configuradas"
    echo "📋 DB_HOST: $DB_HOST"
    echo "📋 DB_DATABASE: $DB_DATABASE"
    echo "📋 DB_USERNAME: $DB_USERNAME"
fi

# Generar key de aplicación si no existe
if [ -z "$APP_KEY" ]; then
    echo "🔑 Generando APP_KEY..."
    php artisan key:generate --force
else
    echo "✅ APP_KEY ya configurado"
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

# Esperar a que la base de datos esté disponible (solo si DB_HOST está configurado)
if [ ! -z "$DB_HOST" ]; then
    echo "⏳ Esperando a que la base de datos esté disponible..."
    until nc -z -v -w30 $DB_HOST ${DB_PORT:-5432}; do
        echo "⏰ Esperando conexión de base de datos..."
        sleep 2
    done
    echo "✅ Base de datos disponible"

    # Ejecutar migraciones
    echo "🔄 Ejecutando migraciones..."
    php artisan migrate --force

    # Verificar si hay seeders para ejecutar
    if [ ! -z "$RUN_SEEDERS" ] && [ "$RUN_SEEDERS" = "true" ]; then
        echo "🌱 Ejecutando seeders..."
        php artisan db:seed --force
    else
        echo "📊 Seeders omitidos (configura RUN_SEEDERS=true para ejecutarlos)"
    fi

    # Generar storage link
    echo "🔗 Creando enlace de almacenamiento..."
    php artisan storage:link --force
else
    echo "⚠️  Base de datos no configurada, omitiendo migraciones"
fi

echo "✅ Despliegue completado!"