FROM php:8.2-cli

# Instala dependencias del sistema
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    libzip-dev \
    sqlite3 \
    libsqlite3-dev \
    && docker-php-ext-install pdo pdo_mysql pdo_sqlite mbstring exif pcntl bcmath gd zip

# Instala Composer
COPY --from=composer:2.7 /usr/bin/composer /usr/bin/composer

# Configura el directorio de trabajo
WORKDIR /var/www/html

# Copia el código de la aplicación
COPY . .

# Compilar assets
RUN if [ -f "package.json" ]; then \
    npm install && npm run build; \
    else \
    php artisan vendor:publish --tag=public --force; \
    fi

# Crear enlace simbólico de storage
RUN php artisan storage:link

# ELIMINAR y CREAR base de datos SQLite
RUN rm -f /var/www/html/database/database.sqlite && \
    mkdir -p /var/www/html/database && \
    touch /var/www/html/database/database.sqlite && \
    chmod 664 /var/www/html/database/database.sqlite

# Instala dependencias de PHP
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage \
    && chmod -R 755 /var/www/html/bootstrap/cache \
    && chmod -R 755 storage bootstrap/cache database \
    && chmod 664 /var/www/html/database/database.sqlite

# Expone el puerto 8000
EXPOSE 8000

# Comando de inicio simplificado
CMD sh -c "php artisan migrate --force && php artisan db:seed --force && php artisan serve --host=0.0.0.0 --port=8000"