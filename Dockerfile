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

# Instala dependencias de PHP
RUN composer install --no-interaction --prefer-dist --optimize-autoloader --no-dev

# Configura permisos
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage \
    && chmod -R 755 /var/www/html/bootstrap/cache

# Crear base de datos SQLite
RUN mkdir -p /var/www/html/database \
    && touch /var/www/html/database/database.sqlite \
    && chmod 664 /var/www/html/database/database.sqlite

# Crear enlace simbólico de storage
RUN php artisan storage:link || ln -sfn /var/www/html/storage/app/public /var/www/html/public/storage

# Optimizar la aplicación con HTTPS forzado
RUN php artisan config:cache && \
    php artisan view:cache && \
    # php artisan route:cache

# Optimizar la aplicación
RUN php artisan optimize:clear && \
    php artisan view:cache && \
    php artisan event:cache

# Expone el puerto 8000
EXPOSE 8000

# Comando de inicio
CMD sh -c "php artisan migrate --force && php artisan db:seed --force && php artisan serve --host=0.0.0.0 --port=8000"