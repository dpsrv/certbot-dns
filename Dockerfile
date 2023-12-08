FROM certbot/certbot

RUN apk --update add bind-tools openssl git \
	&& rm -rf /var/cache/apk/*

COPY certonly*.sh /opt/certbot/
COPY getDomains.sh /opt/certbot/
COPY docker-entrypoint.sh /opt/certbot/

ENTRYPOINT [ "/opt/certbot/docker-entrypoint.sh" ]


