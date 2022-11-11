# OpenSSL, PHP-FPM, шифрование GOST

## Сборка базового образа `openssl-gost-local`

В него входит `openssl` с активированным движком `gost`, а также `curl`, собранный с нашим кастомным `openssl`:

```bash
cd openssl-gost
docker build -t openssl-gost-local .
```

## Сборка образа PHP-FPM

1. Создаем `Dockerfile` в папке `php-fpm-gost` и копируем 
  туда содержимое официального [образа PHP-FPM](https://raw.githubusercontent.com/docker-library/php/master/8.1/buster/fpm/Dockerfile)
2. Вносим в файл изменения:
   * Собираем на основе `openssl-gost-local`
   * Комментируем команды по установке библиотек, т.к. они уже установлены в нашем базовом образе:
     - `ca-certificates`
     - `curl`
     - `libcurl4-openssl-dev` 
     - `libssl-dev`
   * Меняем опцию для openssl: `--with-openssl=/usr/local/ssl`
   * Комментируем костыль, который для нашей сборки не актуален:
     ```
     [ ! -d /usr/include/curl ]; then \
       ln -sT "/usr/include/$debMultiarch/curl" /usr/local/include/curl; \
     fi; \
     ```
3. Копируем вспомогательные скрипты из официального [репозитория PHP-FPM](https://github.com/docker-library/php/tree/master/8.1/buster/fpm)
  в папку `php-fpm-gost`:
   * docker-php-entrypoint
   * docker-php-ext-configure
   * docker-php-ext-enable
   * docker-php-ext-install
   * docker-php-source
4. Даем этим скриптам права на выполнение:
   ```
   cd php-fpm-gost
   chmod +x docker-php-*
   ```
