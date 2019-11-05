FROM alpine:3.10.3 as builder

# Install crystal and dev libs
RUN apk add -u \
	make  \
	crystal \
	shards \
	tzdata \
	libc-dev \
	zlib-dev \
	libressl-dev \
	yaml-dev
