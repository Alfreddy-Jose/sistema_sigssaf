# Usar versión específica de PHP compatible con Laravel 9
FROM php:8.1-apache-bullseye

# Establecer el directorio de trabajo
WORKDIR /var/www/html

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    libpq-dev \
    libzip-dev \
    && docker-php-ext-install pdo pdo_pgsql mbstring exif pcntl bcmath gd zip \
    && a2enmod rewrite

# Instalar Composer
COPY --from=composer:2.4 /usr/bin/composer /usr/bin/composer

# Copiar el código de la aplicación
COPY . .

# Instalar dependencias de PHP (Laravel 9)
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Configurar permisos para Laravel
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage \
    && chmod -R 755 /var/www/html/bootstrap/cache

# Copiar configuración de Apache para Laravel
COPY docker/000-default.conf /etc/apache2/sites-available/000-default.conf

# Exponer el puerto
EXPOSE 80

# Comando de inicio
CMD ["apache2-foreground"]