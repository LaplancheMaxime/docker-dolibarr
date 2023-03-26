ARG ARCHI
FROM ${ARCHI}/php:7.3-apache

# Install the packages we need
# Install the PHP extensions we need
# see https://wiki.dolibarr.org/index.php/Dependencies_and_external_libraries
# Prepare folders
RUN set -ex; \
	apt-get update -q; \
	apt-get install -y --no-install-recommends \
		bzip2 \
		default-mysql-client \
		cron \
		rsync \
		sendmail \
		unzip \
		zip \
	; \
	apt-get install -y --no-install-recommends \
		g++ \
		libcurl4-openssl-dev \
		libfreetype6-dev \
		libicu-dev \
		libjpeg-dev \
		libldap2-dev \
		libmagickcore-dev \
		libmagickwand-dev \
		libmcrypt-dev \
		libpng-dev \
		libpq-dev \
		libxml2-dev \
		libzip-dev \
		unzip \
		zlib1g-dev \
	; \
	debMultiarch="$(dpkg-architecture --query DEB_BUILD_MULTIARCH)"; \
	docker-php-ext-configure ldap --with-libdir="lib/$debMultiarch"; \
	docker-php-ext-configure gd --with-freetype-dir=/usr --with-png-dir=/usr --with-jpeg-dir=/usr; \
	docker-php-ext-configure intl; \
	docker-php-ext-configure zip --with-libzip; \
	docker-php-ext-install -j "$(nproc)" \
		calendar \
		gd \
		intl \
		ldap \
		mbstring \
		mysqli \
		pdo \
		pdo_mysql \
		pdo_pgsql \
		pgsql \
		soap \
		zip \
	; \
	pecl install imagick; \
	docker-php-ext-enable imagick; \
	rm -rf /var/lib/apt/lists/*; \
	mkdir -p /var/www/documents; \
	chown -R www-data:root /var/www; \
	chmod -R g=u /var/www

# Runtime env var
ENV DOLI_AUTO_CONFIGURE 1

ENV	DOLI_DB_TYPE mysqli
ENV	DOLI_DB_HOST mysql
ENV	DOLI_DB_PORT 3306
ENV	DOLI_DB_USER dolibarr
ENV	DOLI_DB_PASSWORD ''
ENV	DOLI_DB_NAME dolibarr
ENV	DOLI_DB_PREFIX llx_
ENV	DOLI_DB_CHARACTER_SET utf8
ENV	DOLI_DB_COLLATION utf8_unicode_ci
ENV	DOLI_DB_ROOT_LOGIN ''
ENV	DOLI_DB_ROOT_PASSWORD ''

ENV	DOLI_ADMIN_LOGIN admin
ENV	DOLI_MODULES ''
ENV	DOLI_URL_ROOT 'http://localhost'
ENV	DOLI_AUTH dolibarr

ENV	DOLI_LDAP_HOST  127.0.0.1
ENV	DOLI_LDAP_PORT 389 
ENV	DOLI_LDAP_VERSION 3 
ENV	DOLI_LDAP_SERVERTYPE openldap 
ENV	DOLI_LDAP_LOGIN_ATTRIBUTE uid 
ENV	DOLI_LDAP_DN '' 
ENV	DOLI_LDAP_FILTER '' 
ENV	DOLI_LDAP_ADMIN_LOGIN '' 
ENV	DOLI_LDAP_ADMIN_PASS '' 
ENV	DOLI_LDAP_DEBUG false 

ENV	DOLI_HTTPS 0
ENV	DOLI_PROD 0

ENV	DOLI_NO_CSRF_CHECK 0

ENV	WWW_USER_ID 33
ENV	WWW_GROUP_ID 33

ENV	PHP_INI_DATE_TIMEZONE 'UTC'
ENV	PHP_MEMORY_LIMIT 256M
ENV	PHP_MAX_UPLOAD 20M
ENV	PHP_MAX_EXECUTION_TIME 300

# Build time env var
ARG DOLI_VERSION=11.0.5
ENV DOLI_VERSION ${DOLI_VERSION}

# Get Dolibarr
ADD https://github.com/Dolibarr/dolibarr/archive/${DOLI_VERSION}.zip /tmp/dolibarr.zip

# Install Dolibarr from tag archive
RUN set -ex; \
	mkdir -p /tmp/dolibarr; \
	unzip -q /tmp/dolibarr.zip -d /tmp/dolibarr; \
	rm /tmp/dolibarr.zip; \
	cp -r /tmp/dolibarr/dolibarr-${DOLI_VERSION}/htdocs/* /var/www/html/; \
	ln -s /var/www/html /var/www/htdocs; \
	cp -r /tmp/dolibarr/dolibarr-${DOLI_VERSION}/scripts /var/www/ ; \
	rm -rf /tmp/dolibarr; \
	chown -R www-data:www-data /var/www; \
	echo "${DOLI_VERSION}" > /var/www/html/.docker-image-version

# Arguments to label built container
ARG VCS_REF
ARG BUILD_DATE

# Container labels (http://label-schema.org/)
# Container annotations (https://github.com/opencontainers/image-spec)
LABEL maintainer="Maxime LAPLANCHE <maxime.laplanche@outlook.com>" \
	  product="Dolibarr" \
	  version=${DOLI_VERSION} \
	  org.label-schema.vcs-ref=${VCS_REF} \
	  org.label-schema.vcs-url="https://gitlab.com/n0xcode/docker-dolibarr" \
	  org.label-schema.build-date=${BUILD_DATE} \
	  org.label-schema.name="Dolibarr" \
	  org.label-schema.description="Open Source ERP & CRM for Business" \
	  org.label-schema.url="https://www.dolibarr.org/" \
	  org.label-schema.vendor="N0xCode" \
	  org.label-schema.version=$DOLI_VERSION \
	  org.label-schema.schema-version="1.0" \
	  org.label-schema.docker.cmd="docker run -d -e DOLI_AUTO_CONFIGURE='' -p 80:80 n0xcode/docker-dolibarr" \
	  org.label-schema.docker.cmd.devel="docker run -d -e DOLI_AUTO_CONFIGURE='' -p 8080:80 n0xcode/docker-dolibarr" \
	  org.opencontainers.image.revision=${VCS_REF} \
	  org.opencontainers.image.source="https://gitlab.com/n0xcode/docker-dolibarr" \
	  org.opencontainers.image.created=${BUILD_DATE} \
	  org.opencontainers.image.title="Dolibarr" \
	  org.opencontainers.image.description="Open Source ERP & CRM for Business" \
	  org.opencontainers.image.url="https://www.dolibarr.org/" \
	  org.opencontainers.image.vendor="N0xCode" \
	  org.opencontainers.image.version=${DOLI_VERSION} \
	  org.opencontainers.image.authors="Maxime LAPLANCHE <maxime.laplanche@outlook.com>"

EXPOSE 80

VOLUME /var/www/documents
VOLUME /var/www/custom

COPY entrypoint.sh /
RUN set -ex; \
	chmod 755 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
