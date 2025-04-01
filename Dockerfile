FROM php:8.2-fpm-alpine

# Instala bash, mysql e dependências do Composer
RUN apk add --no-cache \
    bash \
    mysql-client \
    git \
    curl \
    unzip \
    libzip-dev \
    oniguruma-dev \
    autoconf \
    build-base \
    wget

# Instala extensões PHP
RUN docker-php-ext-install pdo pdo_mysql

# Instala Dockerize
RUN wget https://github.com/jwilder/dockerize/releases/download/v0.6.1/dockerize-linux-amd64-v0.6.1.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-v0.6.1.tar.gz \
    && rm dockerize-linux-amd64-v0.6.1.tar.gz

# Instala Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Define diretório da aplicação
WORKDIR /var/www

# Copia arquivos
COPY . /var/www

# Instala dependências PHP do Laravel
RUN composer install

# Link simbólico para o public
RUN ln -s public html || true  # evita erro se já existir

EXPOSE 9000

# Inicia o PHP-FPM corretamente
CMD ["php-fpm", "-F"]