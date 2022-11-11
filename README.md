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
