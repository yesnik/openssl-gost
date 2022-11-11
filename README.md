# OpenSSL, PHP-FPM, шифрование GOST

## Сборка базового образа `openssl-gost-local`

В него входит `openssl` с активированным движком `gost`, а также `curl`, собранный с нашим кастомным `openssl`:

```bash
cd openssl-gost
docker build -t openssl-gost-local .
```

