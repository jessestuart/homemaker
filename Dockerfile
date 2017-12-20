FROM alpine:latest

ENV ROOT_PASSWORD root
ENV PACKAGES="\
bash \
build-base \
ca-certificates \
dumb-init \
git \
linux-headers \
musl \
openssh \
openssh-server \
py-setuptools \
python2 \
python2-dev \
shadow \
sudo \
"

RUN apk --update add $PACKAGES \
    && sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
    && echo "root:${ROOT_PASSWORD}" | chpasswd \
    && rm -rf /var/cache/apk/* /tmp/* \
    && echo '' > /etc/motd

COPY bin/ssh-entrypoint.sh /usr/local/bin/

EXPOSE 22
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["ssh-entrypoint.sh"]
