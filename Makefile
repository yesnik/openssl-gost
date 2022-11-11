ifndef DOCKERHUB_LOGIN
override DOCKERHUB_LOGIN = yesnik
endif

build-openssl-gost:
ifdef IMAGE_TAG
	# Example: DOCKERHUB_LOGIN=yesnik IMAGE_TAG=1.0 make build-openssl-gost
	docker --log-level=debug build --pull --file=Dockerfile --tag=${DOCKERHUB_LOGIN}/openssl-gost:${IMAGE_TAG} .
else
	@echo 1>&2 "IMAGE_TAG must be set"
endif

build-php-fpm-gost:
ifdef IMAGE_TAG
	# Example: DOCKERHUB_LOGIN=yesnik IMAGE_TAG=1.0 make build-php-fpm-gost
	docker --log-level=debug build --pull --file=Dockerfile --tag=${DOCKERHUB_LOGIN}/php-fpm-gost:${IMAGE_TAG} .
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
