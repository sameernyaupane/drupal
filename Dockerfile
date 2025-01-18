FROM php:7.4-apache

# Install required PHP extensions and dependencies
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libpq-dev \
    libxml2-dev \
    && docker-php-ext-configure gd --with-jpeg \
    && docker-php-ext-install gd mysqli pdo pdo_mysql xml \
    && rm -rf /var/lib/apt/lists/*

# Download and extract Drupal 7
RUN wget https://ftp.drupal.org/files/projects/drupal-7.92.tar.gz && \
    tar xzf drupal-7.92.tar.gz && \
    mv drupal-7.92/* /var/www/html/ && \
    rm drupal-7.92.tar.gz && \
    chown -R www-data:www-data /var/www/html

# Install required modules
RUN cd /var/www/html/sites/all/modules && \
    mkdir -p /var/www/html/sites/all/modules && \
    wget https://ftp.drupal.org/files/projects/date-7.x-2.10.tar.gz && \
    tar xzf date-7.x-2.10.tar.gz && \
    rm date-7.x-2.10.tar.gz && \
    wget https://ftp.drupal.org/files/projects/wysiwyg-7.x-2.9.tar.gz && \
    tar xzf wysiwyg-7.x-2.9.tar.gz && \
    rm wysiwyg-7.x-2.9.tar.gz && \
    wget https://ftp.drupal.org/files/projects/libraries-7.x-2.5.tar.gz && \
    tar xzf libraries-7.x-2.5.tar.gz && \
    rm libraries-7.x-2.5.tar.gz

# Install TinyMCE with correct directory structure
RUN mkdir -p /var/www/html/sites/all/libraries/tinymce && \
    cd /var/www/html/sites/all/libraries/tinymce && \
    wget https://download.tiny.cloud/tinymce/community/tinymce_4.9.11.zip && \
    unzip tinymce_4.9.11.zip && \
    mkdir -p js/tinymce && \
    mv tinymce/js/tinymce/* js/tinymce/ && \
    rm -rf tinymce* && \
    chmod -R 777 .

# Configure Apache
RUN a2enmod rewrite
COPY apache-config.conf /etc/apache2/sites-available/000-default.conf 