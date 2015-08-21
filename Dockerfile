FROM sys42/docker-nginx:1.0.0
MAINTAINER Tom Nussbaumer <thomas.nussbaumer@gmx.net>

ADD . /_tmp

RUN set -e                                && \
    export LC_ALL=C                       && \
    export DEBIAN_FRONTEND=noninteractive && \
    set -x                                && \
    . /etc/environment                    && \
    [ ! -e /var/lib/apt/lists/lock ] && apt-get update       && \
    apt-get install -y --no-install-recommends php5-fpm git     \
            php5-mysql php5-mysql php-apc php5-curl php5-gd     \
            php5-intl php5-mcrypt php5-memcache php5-sqlite     \
            php5-tidy php5-xmlrpc php5-xsl php5-pgsql           \
            php5-mongo pwgen                                 && \
    apt-get clean                                            && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*            && \
    cp /_tmp/cfg/php.ini /etc/php5/fpm                       && \
    cp /_tmp/cfg/php-fpm.conf /etc/php5/fpm                  && \
    cp /_tmp/cfg/www.conf /etc/php5/fpm/pool.d               && \
    mkdir /etc/service/php5-fpm                              && \
    cp /_tmp/runit/php5-fpm /etc/service/php5-fpm/run        && \
    mkdir /etc/service/php-log-forwarder                     && \
    cp /_tmp/runit/php-log-forwarder                            \
       /etc/service/php-log-forwarder/run                    && \
    cp /_tmp/info.php /usr/share/nginx/html                  && \
    cp /_tmp/cfg/default-site /etc/nginx/sites-available/default && \
    rm -rf /_tmp


#### changes in config files

## /etc/php5/fpm/php.ini:

## cgi.fix_pathinfo=1       => cgi.fix_pathinfo=0
## upload_max_filesize = 2M => upload_max_filesize = 100M
## post_max_size = 8M       => post_max_size = 100M
##
## /etc/php5/fpm/php-fpm.conf:
##
## daemonize = yes          => daemonize = no
##
## NOT CHANGED :
##
##
## /etc/php5/fpm/pool.d/www.conf:
##
## pm.max_children = 5      => pm.max_children = 9
## pm.start_servers = 2     => pm.start_servers = 3
## pm.min_spare_servers = 1 => pm.min_spare_servers = 2
## pm.max_spare_servers = 3 => pm.max_spare_servers = 4
## pm.max_requests = 500    => pm.max_requests = 200
## listen.mode = 0660       => listen.mode = 0750     ?????????

## ????
#find /etc/php5/cli/conf.d/ -name "*.ini" -exec sed -i -re 's/^(\s*)#(.*)/\1;\2/g' {} \;
