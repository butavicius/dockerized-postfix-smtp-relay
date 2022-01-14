FROM wordpress:5.8-apache

RUN a2enmod ssl

RUN apt-get update && \
    apt-get upgrade -yqq && \
    echo "postfix postfix/mailname string $MAILNAME" | debconf-set-selections && \
    echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections && \
    apt-get install -yqq postfix rsyslog iproute2 wget libsasl2-modules vim && \
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