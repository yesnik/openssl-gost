ifndef DOCKERHUB_LOGIN
override DOCKERHUB_LOGIN = yesnik
endif

build-all: build-openssl-gost build-php-fpm-gost
push-all: push-openssl-gost push-php-fpm-gost

build-openssl-gost:
ifdef IMAGE_TAG
	# Example: DOCKERHUB_LOGIN=yesnik IMAGE_TAG=1.0 make build-openssl-gost
	docker --log-level=debug build --pull --file=openssl-gost/Dockerfile \
		--tag=${DOCKERHUB_LOGIN}/openssl-gost:${IMAGE_TAG} ./openssl-gost
else
	@echo 1>&2 "IMAGE_TAG must be set"
endif

build-php-fpm-gost:
ifdef IMAGE_TAG
	# Example: DOCKERHUB_LOGIN=yesnik IMAGE_TAG=1.0 make build-php-fpm-gost
	docker --log-level=debug build --pull --file=php-fpm-gost/Dockerfile \
		--tag=${DOCKERHUB_LOGIN}/php-fpm-gost:${IMAGE_TAG} ./php-fpm-gost
else
	@echo 1>&2 "IMAGE_TAG must be set"
endif

push-openssl-gost:
ifdef IMAGE_TAG
	# Example: DOCKERHUB_LOGIN=yesnik IMAGE_TAG=1.0 make push-openssl-gost
	docker push ${DOCKERHUB_LOGIN}/openssl-gost:${IMAGE_TAG}
else
	@echo 1>&2 "IMAGE_TAG must be set"
endif

push-php-fpm-gost:
ifdef IMAGE_TAG
	# Example: DOCKERHUB_LOGIN=yesnik IMAGE_TAG=1.0 make push-php-fpm-gost
	docker push ${DOCKERHUB_LOGIN}/php-fpm-gost:${IMAGE_TAG}
else
	@echo 1>&2 "IMAGE_TAG must be set"
endif
