<!-- >Header -->
[![License: AGPL v3](https://img.shields.io/gitlab/license/n0xcode/docker-dolibarr?color=blue&style=for-the-badge)](https://gitlab.com/n0xcode/docker-dolibarr/-/blob/main/LICENSE)
[![Build Status](https://img.shields.io/gitlab/pipeline-status/n0xcode/docker-dolibarr?branch=main&style=for-the-badge)](https://gitlab.com/n0xcode/docker-dolibarr/-/pipelines?scope=branches)
[![Docker Pulls](https://img.shields.io/docker/pulls/n0xcode/docker-dolibarr?style=for-the-badge)](https://hub.docker.com/r/n0xcode/docker-dolibarr)
[![Latest version](https://img.shields.io/gitlab/v/release/n0xcode/docker-dolibarr?sort=semver&style=for-the-badge)](https://github.com/Dolibarr/dolibarr/releases/)
[![Docker Size](https://img.shields.io/docker/image-size/n0xcode/docker-dolibarr?sort=semver&style=for-the-badge)](https://hub.docker.com/r/n0xcode/docker-dolibarr)
[![Docker stars](https://img.shields.io/docker/stars/n0xcode/docker-dolibarr?style=for-the-badge)](https://hub.docker.com/r/n0xcode/docker-dolibarr)
[![Gitlab stars](https://img.shields.io/gitlab/stars/n0xcode/docker-dolibarr?label=Gitlab%20stars&style=for-the-badge)](https://img.shields.io/gitlab/stars/docker-dolibarr?label=Gitlab%20stars&style=for-the-badge)
[![GitHub stars](https://img.shields.io/github/stars/LaplancheMaxime/docker-dolibarr?label=Github%20stars&style=for-the-badge)](https://img.shields.io/github/stars/LaplancheMaxime/docker-dolibarr?label=Github%20stars&style=for-the-badge)

[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=n0xcode_docker-dolibarr&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=n0xcode_docker-dolibarr)
[![Code Smells](https://sonarcloud.io/api/project_badges/measure?project=n0xcode_docker-dolibarr&metric=code_smells)](https://sonarcloud.io/summary/new_code?id=n0xcode_docker-dolibarr)
[![Reliability Rating](https://sonarcloud.io/api/project_badges/measure?project=n0xcode_docker-dolibarr&metric=reliability_rating)](https://sonarcloud.io/summary/new_code?id=n0xcode_docker-dolibarr)
[![Vulnerabilities](https://sonarcloud.io/api/project_badges/measure?project=n0xcode_docker-dolibarr&metric=vulnerabilities)](https://sonarcloud.io/summary/new_code?id=n0xcode_docker-dolibarr)
[![Bugs](https://sonarcloud.io/api/project_badges/measure?project=n0xcode_docker-dolibarr&metric=bugs)](https://sonarcloud.io/summary/new_code?id=n0xcode_docker-dolibarr)
[![Security Rating](https://sonarcloud.io/api/project_badges/measure?project=n0xcode_docker-dolibarr&metric=security_rating)](https://sonarcloud.io/summary/new_code?id=n0xcode_docker-dolibarr)
[![Maintainability Rating](https://sonarcloud.io/api/project_badges/measure?project=n0xcode_docker-dolibarr&metric=sqale_rating)](https://sonarcloud.io/summary/new_code?id=n0xcode_docker-dolibarr)
<!-- <Header -->
# Dolibarr on Docker

Docker image for Dolibarr.

Provides full database configuration, production mode, HTTPS enforcer (SSL must be provided by reverse proxy), handles upgrades, and so on...

**[View full documentation here](https://gitlab.com/n0xcode/docker-dolibarr/-/tree/main/docs/README.md)**

## What is Dolibarr

Dolibarr ERP & CRM is a modern software package to manage your organization's activity (contacts, suppliers, invoices, orders, stocks, agenda, ...).

> [More informations](https://github.com/dolibarr/dolibarr)

## Supported tags and respective Dockerfile links

[Dockerhub n0xcode/docker-dolibarr](https://hub.docker.com/r/n0xcode/docker-dolibarr)

Tags:

<!-- >DockerTags -->
|Version|Tags|Architecture|PHP|
|---|---|---|---|
|[18.0](./images/18.0)|`18.0.1-apache` `18.0-apache` `apache` `18.0.1` `18.0` `latest`|amd64, i386|8.1|
|[18.0](./images/18.0)|`18.0.1-fpm` `18.0-fpm` `fpm`|amd64, i386|8.1|
|[18.0](./images/18.0)|`18.0.1-fpm-alpine` `18.0-fpm-alpine` `fpm-alpine`|amd64, i386|8.1|
|[17.0](./images/17.0)|`17.0.3-apache` `17.0-apache` `17.0.3` `17.0`|amd64, i386|8.1|
|[17.0](./images/17.0)|`17.0.3-fpm` `17.0-fpm`|amd64, i386|8.1|
|[17.0](./images/17.0)|`17.0.3-fpm-alpine` `17.0-fpm-alpine`|amd64, i386|8.1|
|[16.0](./images/16.0)|`16.0.5-apache` `16.0-apache` `16.0.5` `16.0`|amd64, i386|8.1|
|[16.0](./images/16.0)|`16.0.5-fpm` `16.0-fpm`|amd64, i386|8.1|
|[16.0](./images/16.0)|`16.0.5-fpm-alpine` `16.0-fpm-alpine`|amd64, i386|8.1|
|[15.0](./images/15.0)|`15.0.3-apache` `15.0-apache` `15.0.3` `15.0`|amd64, i386|7.3|
|[15.0](./images/15.0)|`15.0.3-fpm` `15.0-fpm`|amd64, i386|7.3|
|[15.0](./images/15.0)|`15.0.3-fpm-alpine` `15.0-fpm-alpine`|amd64, i386|7.3|
|[14.0](./images/14.0)|`14.0.5-apache` `14.0-apache` `14.0.5` `14.0`|amd64, i386|7.3|
|[14.0](./images/14.0)|`14.0.5-fpm` `14.0-fpm`|amd64, i386|7.3|
|[14.0](./images/14.0)|`14.0.5-fpm-alpine` `14.0-fpm-alpine`|amd64, i386|7.3|
|[13.0](./images/13.0)|`13.0.5-apache` `13.0-apache` `13.0.5` `13.0`|amd64, i386|7.3|
|[13.0](./images/13.0)|`13.0.5-fpm` `13.0-fpm`|amd64, i386|7.3|
|[13.0](./images/13.0)|`13.0.5-fpm-alpine` `13.0-fpm-alpine`|amd64, i386|7.3|
|[12.0](./images/12.0)|`12.0.5-apache` `12.0-apache` `12.0.5` `12.0`|amd64, i386|7.3|
|[12.0](./images/12.0)|`12.0.5-fpm` `12.0-fpm`|amd64, i386|7.3|
|[12.0](./images/12.0)|`12.0.5-fpm-alpine` `12.0-fpm-alpine`|amd64, i386|7.3|
<!-- <DockerTags -->
<https://wiki.dolibarr.org/index.php?title=Versions>

<!-- >SupportedArchitectures -->
## Quick reference

- **Supported architectures**:([more info](https://github.com/docker-library/official-images#architectures-other-than-amd64))
  - [`amd64`](https://hub.docker.com/r/amd64/php/)
  - [`i386`](https://hub.docker.com/r/i386/php/)
<!-- <SupportedArchitectures -->

<!-- >HowToRun -->
## How to run this image

This image is based on the [officiel PHP repository](https://registry.hub.docker.com/_/php/).
It is inspired from [nextcloud](https://github.com/nextcloud/docker), [tuxgasy/docker-dolibarr](https://github.com/tuxgasy/docker-dolibarr) and [Monogramm/docker-dolibarr](https://github.com/Monogramm/docker-dolibarr).

This image does not contain the database for Dolibarr. You need to use either an existing database or a database container.

This image is designed to be used in a micro-service environment. There are two versions of the image you can choose from.

The `apache` tag contains a full Dolibarr installation including an apache web server. It is designed to be easy to use and gets you running pretty fast. This is also the default for the `latest` tag and version tags that are not further specified.

The second option is a `fpm` container. It is based on the [php-fpm](https://hub.docker.com/_/php/) image and runs a fastCGI-Process that serves your Dolibarr page. To use this image it must be combined with any webserver that can proxy the http requests to the FastCGI-port of the container.
<!-- <HowToRun -->

## Questions / Issues

If you got any questions or problems using the image, please visit our [Gitlab Repository](https://gitlab.com/n0xcode/docker-dolibarr) and write an issue.  
