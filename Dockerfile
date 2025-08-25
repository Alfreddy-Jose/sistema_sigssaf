# Usar PHP 8.2
FROM php:8.2-apache-bullseye

# Establecer el directorio de trabajo
WORKDIR /var/www/html

# Actualizar lista de paquetes e instalar dependencias
RUN apt-get update && apt-get install -y --no-install-recommends \
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
    && rm -rf /var/lib/apt/lists/*

# Instalar extensiones de PHP
RUN docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd zip

# Habilitar mod_rewrite de Apache
RUN a2enmod rewrite

# Instalar Composer
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# Crear carpeta database y archivo SQLite
RUN mkdir -p database && touch database/database.sqlite

# Copiar primero solo los archivos de Composer para mejor caching
COPY composer.json composer.lock ./

# Instalar dependencias de PHP
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Copiar el resto del código (INCLUYENDO deploy.sh)
COPY . .

# Configurar permisos para Laravel y SQLite
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage \
    && chmod -R 755 /var/www/html/bootstrap/cache \
    && chmod 664 /var/www/html/database/database.sqlite \
    && chmod 775 /var/www/html/database

# Verificar que deploy.sh existe y dar permisos
RUN if [ ! -f /usr/local/bin/deploy.sh ]; then \
    echo "❌ deploy.sh no encontrado, copiando..."; \
    cp deploy.sh /usr/local/bin/deploy.sh; \
    fi

RUN chmod +x /usr/local/bin/deploy.sh

# Exponer el puerto
EXPOSE 80

# Comando de inicio (usando ruta absoluta)
CMD ["sh", "-c", "/usr/local/bin/deploy.sh && apache2-foreground"]