#!/bin/bash

MYSQL_USER=${MYSQL_USER:-admin}
MYSQL_PASS=${MYSQL_PASS:-qwerty15}

if [ ! -f /.mysql_ready ]; then
  service mysql start
  mysql -uroot << EOF
    # set up mroonga engine.
    INSTALL PLUGIN mroonga SONAME 'ha_mroonga.so';
    CREATE FUNCTION last_insert_grn_id RETURNS INTEGER SONAME 'ha_mroonga.so';
    CREATE FUNCTION mroonga_snippet RETURNS STRING SONAME 'ha_mroonga.so';
    CREATE FUNCTION mroonga_command RETURNS STRING SONAME 'ha_mroonga.so';
    CREATE FUNCTION mroonga_escape RETURNS STRING SONAME 'ha_mroonga.so';

    # create master user.
    GRANT ALL PRIVILEGES ON *.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASS' WITH GRANT OPTION;

    # cleanup dirty settings.
    DROP DATABASE test;
    DELETE FROM mysql.db WHERE Db = 'test' OR Db='test\\_%';
    DELETE FROM mysql.user WHERE User IN ('root', '');
EOF
  service mysql stop
  touch /.mysql_ready
fi

mysqld_safe
