FROM wordpress:5.8-apache
RUN a2dissite 000-default
COPY ./apache-conf/http.conf ./apache-conf/https-letsencrypt.conf /etc/apache2/sites-enabled/

# Install postfix and certbot

# We need to change hostname for this step because postfix generates main.cf with error etherwise:
# https://bugs.launchpad.net/ubuntu/+source/postfix/+bug/1906970

RUN echo "echo localhost.localdomain" > /usr/bin/hostname && \
    chmod +x /usr/bin/hostname && \ 
    apt-get update && \
    apt-get upgrade -yqq && \
    echo "postfix postfix/mailname string $MAILNAME" | debconf-set-selections && \
    echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections && \
    apt-get install -yqq postfix rsyslog iproute2 wget libsasl2-modules vim snapd && \
    snap install core && \
    snap refresh core && \
    ln -s /snap/bin/certbot /usr/bin/certbot && \
    apt-get clean -yqq && \
    apt-get autoclean -yqq && \
    apt-get autoremove -yqq && \
    rm -rf /var/cache/apt/archives/* /var/cache/apt/*.bin /var/lib/apt/lists/*

ADD entrypoint sendmail_test /usr/local/bin/

RUN chmod a+rx /usr/local/bin/* && \
    postconf -e smtp_tls_security_level=may && \
    postconf -e smtp_sasl_auth_enable=yes && \
    postconf -e smtp_sasl_password_maps=hash:/etc/postfix/sasl_passwd && \
    postconf -e smtp_sasl_security_options=noanonymous

ENTRYPOINT ["/usr/local/bin/entrypoint"]