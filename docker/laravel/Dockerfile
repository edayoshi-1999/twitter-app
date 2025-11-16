# PHP 8.2 FPM Alpine ベースイメージ
FROM php:8.2-fpm-alpine

# 作業ディレクトリ設定
WORKDIR /var/www/html

# 必要なパッケージとPHP拡張機能のインストール
RUN apk add --no-cache \
    # 基本的なツール
    git \
    curl \
    zip \
    unzip \
    # PostgreSQL クライアントライブラリ
    postgresql-dev \
    # libzip（zip拡張用）
    libzip-dev \
    # 画像処理ライブラリ（将来的に必要になる可能性）
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    # ビルドツール
    && docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg \
    # PHP拡張機能のインストール
    && docker-php-ext-install \
        pdo_pgsql \
        pgsql \
        mbstring \
        zip \
        bcmath \
        opcache \
        gd \
    # 不要なパッケージを削除（イメージサイズ削減）
    && apk del --no-cache \
        freetype-dev \
        libjpeg-turbo-dev \
        libpng-dev

# Composer のインストール（公式の推奨方法）
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# PHP 設定ファイルのカスタマイズ（開発環境向け）
RUN cp "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini" \
    && echo "upload_max_filesize = 10M" >> "$PHP_INI_DIR/php.ini" \
    && echo "post_max_size = 10M" >> "$PHP_INI_DIR/php.ini" \
    && echo "memory_limit = 256M" >> "$PHP_INI_DIR/php.ini"

# www-data ユーザーに適切な権限を設定
RUN chown -R www-data:www-data /var/www/html

# www-data ユーザーで実行
USER www-data

# PHP-FPM のポート公開
EXPOSE 9000

# PHP-FPM の起動
CMD ["php-fpm"]
