#!/bin/sh
set -e

readonly PHP_INI_FILE="/usr/local/etc/php/php.ini"
readonly HTML_DOC_ROOT="/var/www/html"
readonly DOCUMENTS_DIR="/var/www/documents"
readonly HTDOCS_DIR="/var/www/htdocs"
readonly SCRIPTS_DIR="/var/www/scripts"
readonly HTML_CONF_DIR="/var/www/html/conf/"
readonly CONF_FILE="${HTML_CONF_DIR}/conf.php"
readonly INSTALL_LOCK="${DOCUMENTS_DIR}/install.lock"
readonly DOCKER_CONTAINER_VERSION_FILE="${HTML_DOC_ROOT}/.docker-container-version"
readonly DOCKER_INSTALL_VERSION_FILE="/tmp/lastinstall.result "
readonly WWW_USER="www-data"

log() {
    printf "[%s] [%s] [%s] %s\n" "$(date +'%Y-%m-%d %T')" "$$" "$0" "$*"
}

create_dir() {
  if [ ! -d "$1" ]; then
    log "Creating directory $1"
    mkdir -p "$1"
    chown $WWW_USER:$WWW_USER "$1"
  else
	log "$1 directory already exists"
  fi
}

waitForDataBase() {
  until mysql -u "${DOLI_DB_USER}" --protocol tcp -p"${DOLI_DB_PASSWORD}" -h "${DOLI_DB_HOST}" -P "${DOLI_DB_HOST_PORT}" --connect-timeout=5 -e "status" > /dev/null 2>&1; do
    log "[DB] Waiting for SQL database to be up..."
    sleep 2
  done
	log "[RUN] - Dolibarr database is up"
}

# version_greater A B returns whether A > B
version_greater() {
    [ "$(printf '%s\n' "$@" | sort -t '.' -n -k1,1 -k2,2 -k3,3 -k4,4 | head -n 1)" != "$1" ]
}

# return true if specified directory is empty
directory_empty() {
    [ -z "$(find "$1" -maxdepth 0 -empty)" ]
}

run_as() {
	if [ "$(id -u)" = 0 ]; then
		su - $WWW_USER -s /bin/sh -c "$1"
	else
		sh -c "$1"
	fi
}

lockInstallation()
{
  echo '' > "$INSTALL_LOCK"
  chown "$WWW_USER":"$WWW_USER" "$INSTALL_LOCK"
  chmod 400 "$INSTALL_LOCK"
}

init_dolibarr(){
	create_dir "$DOCUMENTS_DIR"
	create_dir "$HTML_CONF_DIR"
	
	# Update Dolibarr users and group
	log "[INIT] - Updating Dolibarr users and group..."
	if [ "$WWW_USER_ID" != "$(id -u $WWW_USER)" ]; then
		run_as "usermod -u $WWW_USER_ID $WWW_USER"
	fi
	if [ "$WWW_GROUP_ID" != "$(id -g $WWW_USER)" ]; then
		run_as "groupmod -g "$WWW_GROUP_ID" "$WWW_USER""
	fi

	# Update Dolibarr folder ownership
	log "[INIT] - Updating Dolibarr folder ownership..."
	chown -R "$WWW_USER":"$WWW_USER" "$HTML_DOC_ROOT" "$DOCUMENTS_DIR"

	if [ ! -f "$PHP_INI_FILE" ]; then
	log "[INIT] - Initializing PHP configuration..."
	cat <<EOF > "$PHP_INI_FILE"
date.timezone = "${PHP_INI_DATE_TIMEZONE}"
memory_limit = ${PHP_MEMORY_LIMIT}
file_uploads = On
upload_max_filesize = ${PHP_MAX_UPLOAD}
post_max_size = ${PHP_MAX_UPLOAD}
max_execution_time = ${PHP_MAX_EXECUTION_TIME}
sendmail_path = /usr/sbin/sendmail -t -i
extension = calendar.so
EOF
	fi
 
	# Create a default config if autoconfig enabled
	if [ -n "$DOLI_AUTO_CONFIGURE" ] && [ ! -f "$CONF_FILE" ]; then
		log "[INIT] - Initializing Dolibarr configuration : $CONF_FILE"
		cat <<EOF > "$CONF_FILE"
<?php
// Config file for Dolibarr ${DOLI_VERSION} ($(date +%Y-%m-%dT%H:%M:%S%:z))

// ###################
// # Main parameters #
// ###################
\$dolibarr_main_url_root='${DOLI_URL_ROOT}';
\$dolibarr_main_document_root='/var/www/html';
\$dolibarr_main_url_root_alt='/custom';
\$dolibarr_main_document_root_alt='/var/www/html/custom';
\$dolibarr_main_data_root='/var/www/documents';
\$dolibarr_main_db_host='${DOLI_DB_HOST}';
\$dolibarr_main_db_port='${DOLI_DB_PORT}';
\$dolibarr_main_db_name='${DOLI_DB_NAME}';
\$dolibarr_main_db_prefix='${DOLI_DB_PREFIX}';
\$dolibarr_main_db_user='${DOLI_DB_USER}';
\$dolibarr_main_db_pass='${DOLI_DB_PASSWORD}';
\$dolibarr_main_db_type='${DOLI_DB_TYPE}';
\$dolibarr_main_db_character_set='${DOLI_DB_CHARACTER_SET}';
\$dolibarr_main_db_collation='${DOLI_DB_COLLATION}';

// ##################
// # Login          #
// ##################
\$dolibarr_main_authentication='${DOLI_AUTH}';
\$dolibarr_main_auth_ldap_host='${DOLI_LDAP_HOST}';
\$dolibarr_main_auth_ldap_port='${DOLI_LDAP_PORT}';
\$dolibarr_main_auth_ldap_version='${DOLI_LDAP_VERSION}';
\$dolibarr_main_auth_ldap_servertype='${DOLI_LDAP_SERVERTYPE}';
\$dolibarr_main_auth_ldap_login_attribute='${DOLI_LDAP_LOGIN_ATTRIBUTE}';
\$dolibarr_main_auth_ldap_dn='${DOLI_LDAP_DN}';
\$dolibarr_main_auth_ldap_filter ='${DOLI_LDAP_FILTER}';
\$dolibarr_main_auth_ldap_admin_login='${DOLI_LDAP_ADMIN_LOGIN}';
\$dolibarr_main_auth_ldap_admin_pass='${DOLI_LDAP_ADMIN_PASS}';
\$dolibarr_main_auth_ldap_debug='${DOLI_LDAP_DEBUG}';

// ##################
// # Security       #
// ##################
\$dolibarr_main_prod='${DOLI_PROD}';
\$dolibarr_main_force_https='${DOLI_HTTPS}';
\$dolibarr_main_restrict_os_commands='mysqldump, mysql, pg_dump, pgrestore';
\$dolibarr_nocsrfcheck='${DOLI_NO_CSRF_CHECK}';
\$dolibarr_main_cookie_cryptkey='$(openssl rand -hex 32)';
\$dolibarr_mailing_limit_sendbyweb='0';
EOF
	fi

		chown "$WWW_USER":"$WWW_USER" "$CONF_FILE"
		chmod 440 "$CONF_FILE"

	if [ "${DOLI_DB_TYPE}" = "pgsql" ] && [ ! -f "$INSTALL_LOCK" ]; then
		log "[INIT] - chmod 600 for pgsql : $CONF_FILEs"
    chmod 600 "$CONF_FILE"
  else
		log "[INIT] - chmod 400 : $CONF_FILE"
    chmod 400 "$CONF_FILE"
  fi
}

run() {
	log "[INIT] - Dolibarr"
	init_dolibarr
	log "[INIT] - Dolibarr init ok"
	if [ -n "$DOLI_AUTO_CONFIGURE" ]; then

		log "[RUN] - Dolibarr auto-configuration enabled"
		waitForDataBase

		if [ -f $INSTALL_LOCK ]; then 
			mysql -u "${DOLI_DB_USER}" --protocol tcp -p"${DOLI_DB_PASSWORD}" -h "${DOLI_DB_HOST}" -P "${DOLI_DB_HOST_PORT}" --connect-timeout=5 "${DOLI_DB_NAME}" -e "SELECT Q.LAST_INSTALLED_VERSION FROM (SELECT INET_ATON(CONCAT(value, REPEAT('.0', 3 - CHAR_LENGTH(value) + CHAR_LENGTH(REPLACE(value, '.', ''))))) as VERSION_ATON, value as LAST_INSTALLED_VERSION FROM llx_const WHERE name IN ('MAIN_VERSION_LAST_INSTALL', 'MAIN_VERSION_LAST_UPGRADE') and entity=0) Q ORDER BY VERSION_ATON DESC LIMIT 1" > "$DOCKER_INSTALL_VERSION_FILE" 2>&1
			log " result mysql : $(grep -v LAST_INSTALLED_VERSION "$DOCKER_INSTALL_VERSION_FILE")"
		fi
		INSTALLED_VERSION="0.0.0.0"
		if [ -f "$DOCKER_INSTALL_VERSION_FILE" ]; then
			INSTALLED_VERSION=$(grep -v LAST_INSTALLED_VERSION "$DOCKER_INSTALL_VERSION_FILE")
		fi

		log "[RUN] - Last installed version: $INSTALLED_VERSION"

		if version_greater "$INSTALLED_VERSION" "${DOLI_VERSION}"; then
			log "[ERROR] - Can't start Dolibarr because the version of the data ($INSTALLED_VERSION) is higher than the docker image version (${DOLI_VERSION}) and downgrading is not supported. Are you sure you have pulled the newest image version?"
			exit 1
		elif version_greater "${DOLI_VERSION}" "$INSTALLED_VERSION"; then
      	log "[UPGRADE] - Dolibarr upgrade initialization..."
				if [ "$INSTALLED_VERSION" != "0.0.0.0" ]; then
					# Call upgrade if needed
					# https://wiki.dolibarr.org/index.php/Installation_-_Upgrade#With_Dolibarr_.28standard_.zip_package.29
					log "[UPGRADE] - Dolibarr upgrade from $INSTALLED_VERSION to ${DOLI_VERSION}..."

					if [ -f "$INSTALL_LOCK" ]; then
						rm "$INSTALL_LOCK"
					fi

					base_version=$(printf "${INSTALLED_VERSION}" | sed -e 's|\(.*\..*\)\..*|\1|g')
					target_version=$(printf "${DOLI_VERSION}" | sed -e 's|\(.*\..*\)\..*|\1|g')
					log "[UPGRADE] - First step"
					run_as "cd /var/www/html/install/ && php upgrade.php ${base_version}.0 ${target_version}.0"
					log "[UPGRADE] - Second step"
					run_as "cd /var/www/html/install/ && php upgrade2.php ${base_version}.0 ${target_version}.0"
					log "[UPGRADE] - Third step"
					run_as "cd /var/www/html/install/ && php step5.php ${base_version}.0 ${target_version}.0"

					echo 'This is a lock file to prevent use of install pages (generated by container entrypoint)' > /var/www/documents/install.lock
					chown "$WWW_USER":"$WWW_USER" "$INSTALL_LOCK"
					chmod 400 "$INSTALL_LOCK"
				elif [ -n "$DOLI_AUTO_CONFIGURE" ] && [ ! -f "$INSTALL_LOCK" ]; then
					log "[INSTALL] - Create forced values for first Dolibarr install..."
					cat <<EOF > /var/www/html/install/install.forced.php
<?php
// Forced install config file for Dolibarr ${DOLI_VERSION} ($(date +%Y-%m-%dT%H:%M:%S%:z))

/** @var bool Hide PHP informations */
\$force_install_nophpinfo = true;

/** @var int 1 = Lock and hide environment variables, 2 = Lock all set variables */
\$force_install_noedit = 2;

/** @var string Information message */
\$force_install_message = 'Dolibarr installation (Docker)';

/** @var string Data root absolute path (documents folder) */
\$force_install_main_data_root = '/var/www/documents';

/** @var bool Force HTTPS */
\$force_install_mainforcehttps = !empty('${DOLI_HTTPS}');

/** @var string Database name */
\$force_install_database = '${DOLI_DB_NAME}';

/** @var string Database driver (mysql|mysqli|pgsql|mssql|sqlite|sqlite3) */
\$force_install_type = '${DOLI_DB_TYPE}';

/** @var string Database server host */
\$force_install_dbserver = '${DOLI_DB_HOST}';

/** @var int Database server port */
\$force_install_port = '${DOLI_DB_PORT}';

/** @var string Database tables prefix */
\$force_install_prefix = '${DOLI_DB_PREFIX}';

/** @var string Database username */
\$force_install_databaselogin = '${DOLI_DB_USER}';

/** @var string Database password */
\$force_install_databasepass = '${DOLI_DB_PASSWORD}';

/** @var bool Force database user creation */
\$force_install_createuser = false;

/** @var bool Force database creation */
\$force_install_createdatabase = !empty('${DOLI_DB_ROOT_LOGIN}');

/** @var string Database root username */
\$force_install_databaserootlogin = '${DOLI_DB_ROOT_LOGIN}';

/** @var string Database root password */
\$force_install_databaserootpass = '${DOLI_DB_ROOT_PASSWORD}';

/** @var string Dolibarr super-administrator username */
\$force_install_dolibarrlogin = '${DOLI_ADMIN_LOGIN}';

/** @var bool Force install locking */
\$force_install_lockinstall = true;

/** @var string Enable module(s) (Comma separated class names list) */
\$force_install_module = '${DOLI_MODULES}';

EOF

				log "[INSTALL] - You shall complete Dolibarr install manually at '${DOLI_URL_ROOT}/install'"
			fi
			if [ ! -d "$HTDOCS_DIR" ]; then
				log "[RUN] - Adding a symlink to "$HTDOCS_DIR"..."
				ln -s "$HTML_DOC_ROOT" "$HTDOCS_DIR"
			fi

			if [ -f "$INSTALL_LOCK" ]; then
				log "[RUN] - Updating Dolibarr installed version..."
				echo "$image_version" > "$DOCKER_CONTAINER_VERSION_FILE"
			fi
    else
        log "[RUN] - Schema update is not required ... Enjoy !!"
    fi
	fi
}

run

log "[RUN] - Serving Dolibarr..."
exec "$@"
