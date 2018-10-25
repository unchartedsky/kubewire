FROM debian
LABEL maintainer "Bartek Antoniak <antoniaklja@gmail.com>"

EXPOSE 5182/udp
EXPOSE 5182/tcp

# RUN apk add -U wireguard-tools bash iptables linux-headers socat --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/

RUN apt-get update -y && \
    apt-get install -y software-properties-common iptables curl iproute2 ifupdown iputils-ping && \
    echo resolvconf resolvconf/linkify-resolvconf boolean false | debconf-set-selections && \
    echo "REPORT_ABSENT_SYMLINK=no" >> /etc/default/resolvconf && \
    apt-get install -y resolvconf socat supervisor && \
    echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable-wireguard.list && \
   	printf 'Package: *\nPin: release a=unstable\nPin-Priority: 150\n' > /etc/apt/preferences.d/limit-unstable 
   	# apt update -y && \
   	# apt upgrade -y
   	# apt-get install -y wireguard


COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY start-wg.sh /usr/local/bin/start-wg.sh
COPY start-wg-virtual-peer.sh /usr/local/bin/start-wg-virtual-peer.sh
COPY start-socat-recv.sh /usr/local/bin/start-socat-recv.sh
COPY start-socat-send.sh /usr/local/bin/start-socat-send.sh

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
# COPY add_peer.sh /usr/local/bin/add_peer.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/bin/supervisord"]
