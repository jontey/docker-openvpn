# Original credit: https://github.com/jpetazzo/dockvpn

# Smallest base image
FROM alpine:latest

LABEL maintainer="Jonathan Tey <jontey88@gmail.com>"

# Testing: pamtester
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories && \
    apk add --no-cache --update openvpn iptables bash easy-rsa openvpn-auth-pam google-authenticator pamtester libqrencode tcpdump socat supervisor && \
    ln -s /usr/share/easy-rsa/easyrsa /usr/local/bin && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

# Needed by scripts
ENV OPENVPN=/etc/openvpn
ENV EASYRSA=/usr/share/easy-rsa \
    EASYRSA_CRL_DAYS=3650 \
    EASYRSA_PKI=$OPENVPN/pki

VOLUME ["/etc/openvpn"]

# Internally uses port 1194/udp, remap using `docker run -p 443:1194/tcp`
EXPOSE 1194/tcp

COPY ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*
COPY supervisord.conf /etc/supervisord.conf

# Add support for OTP authentication using a PAM module
ADD ./otp/openvpn /etc/pam.d/

CMD ["supervisord", "-c", "/etc/supervisord.conf"]
