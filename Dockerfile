FROM certbot/certbot

COPY certonly.sh /opt/certbot/
COPY getDomains.sh /opt/certbot/
COPY docker-entrypoint.sh /opt/certbot/

ENTRYPOINT [ "/opt/certbot/docker-entrypoint.sh" ]


