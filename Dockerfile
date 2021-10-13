FROM nginx:alpine

RUN apk add --no-cache --update curl bash unzip

COPY default.conf.template /etc/nginx/conf.d/default.conf.template
COPY config.json.template /etc/nginx/conf.d/config.json.template
COPY configm.json.template /etc/nginx/conf.d/configm.json.template
COPY nginx.conf /etc/nginx/nginx.conf
COPY static-html /usr/share/nginx/html
COPY start.sh /usr/start.sh

CMD /bin/bash -c "envsubst '\$PORT,\$WSPATH' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf" \
    && /bin/bash -c "envsubst < /etc/nginx/conf.d/config.json.template > /usr/config.json"       \
    && /bin/bash -c "envsubst < /etc/nginx/conf.d/configm.json.template > /usr/configm.json"       \
    && /bin/bash -c "cat /usr/start.sh | tr -d '\r' > /usr/startnew.sh && nohup sh  /usr/startnew.sh >/dev/null 2>&1 &" \
    && nginx -g 'daemon off;'
