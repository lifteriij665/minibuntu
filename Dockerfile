FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        bash \
        ca-certificates \
        curl \
        wget \
        git \
        iproute2 \
        procps \
        psmisc \
        net-tools \
        python3 \
        openvpn \
        iptables \
        nginx \
        supervisor \
        ttyd \
        && \
    rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 \
    https://github.com/baoweise-bot/aimili-vpngate.git \
    /opt/aimilivpn

RUN mkdir -p /opt/aimilivpn/vpngate_data

COPY nginx.conf /etc/nginx/nginx.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY start.sh /start.sh

RUN chmod +x /start.sh

WORKDIR /root

CMD ["/start.sh"]