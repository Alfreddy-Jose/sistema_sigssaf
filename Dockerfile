# Usar versión específica de PHP compatible con Laravel 9
FROM php:8.1-apache-bullseye

# Establecer el directorio de trabajo
WORKDIR /var/www/html

# Actualizar lista de paquetes e instalar dependencias CON MANEJO DE ERRORES
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    libpq-dev \
    libzip-dev \
    sqlite3 \
    libsqlite3-dev \
    && rm -rf /var/lib/apt/lists/*

# Instalar extensiones de PHP por separado
RUN docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd zip

# Habilitar mod_rewrite de Apache
RUN a2enmod rewrite

# Instalar Composer
COPY --from=composer:2.4 /usr/bin/composer /usr/bin/composer

# Crear carpeta database y archivo SQLite
RUN mkdir -p database && touch database/database.sqlite

# Copiar el código de la aplicación
COPY . .

# Instalar dependencias de PHP (Laravel 9)
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Configurar permisos para Laravel y SQLite
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage \
    && chmod -R 755 /var/www/html/bootstrap/cache \
    && chmod 664 /var/www/html/database/database.sqlite \
    && chmod 775 /var/www/html/database

# Copiar script de despliegue
COPY deploy.sh /usr/local/bin/deploy.sh
RUN chmod +x /usr/local/bin/deploy.sh

# Exponer el puerto
EXPOSE 80

# Comando de inicio
CMD ["sh", "-c", "deploy.sh && apache2-foreground"]