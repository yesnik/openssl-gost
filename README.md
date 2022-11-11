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
5. Собираем образ `php-fpm-gost-local`:
   ```bash
   cd php-fpm-gost
   docker build -t php-fpm-gost-local .
   ```
6. Проверяем. 
   * Запускаем контейнер на базе собранного образа и подключаемся к нему: `docker run --rm -it php-fpm-gost-local bash`
   * Есть ли в openssl шифрование ГОСТ?
   ```
   openssl ciphers | grep GOST
   ```
   Если команда выведет список, то все ОК.
   * Поддерживает ли curl алгоритм ГОСТ? Для этого нам нужно подключиться к сайту, умеющему работать только по ГОСТ.
   Попробуйте открыть в браузере Google Chrome сайт: https://portal.rosreestr.ru:4455/ . Увидите ошибку:
   ```
   Этот сайт не может обеспечить безопасное соединение
   На сайте portal.rosreestr.ru используется неподдерживаемый протокол.
   ERR_SSL_VERSION_OR_CIPHER_MISMATCH
   ```
   Делаем запрос к этому сайту через curl:
   ```bash
   curl "https://portal.rosreestr.ru:4455" -k
   ```
   Если вы увидите ответ nginx, то все ОК.
