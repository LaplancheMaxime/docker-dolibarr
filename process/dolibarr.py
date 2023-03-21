"""Module with dolibarr method."""
# -*- coding: utf-8 -*-
import json
import requests

# Minimum version of Dolibarr to build Docker images for
MIN_VERSION = "11.0.0"

# List of base image variants to build images for
VARIANTS = [
    "apache",
    "fpm",
    "fpm-alpine"
]

# Dictionary of base images and their corresponding server web variants
SERVERS_WEB_VARIANTS = {
    'apache': '',
    'fpm': 'nginx',
    'fpm-alpine': 'nginx'
}

# Dictionary of base images and their corresponding command variants
CMD_VARIANTS = {
    'apache': 'apache2-foreground',
    'fpm': 'php-fpm',
    'fpm-alpine': 'php-fpm'
}

# Dictionary of base images and their corresponding Dockerfile variants
BASES_IMAGES_VARIANTS = {
    'apache': 'debian',
    'fpm': 'debian',
    'fpm-alpine': 'alpine'
}

# Dictionary of base images and their corresponding Docker Compose variants
COMPOSE_VARIANTS = {
    'apache': 'apache',
    'fpm': 'fpm',
    'fpm-alpine': 'fpm'
}

def get_dolibarr_tags():
    """Get dolibarr latests tags"""
    dolibarr_tags = requests.get(
        "https://api.github.com/repos/dolibarr/dolibarr/tags",
        verify=False
    )

    return json.loads(dolibarr_tags.text)

def get_php_version(version):
    """Get php version by dolibarr major version"""
    if version <= "15.0":
        return "7.3"
    return "8.1"
