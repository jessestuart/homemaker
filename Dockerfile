FROM jessestuart/phusion-baseimage
LABEL maintainer="Jesse Stuart <hi@jessestuart.com>"

ENV ROOT_PASSWORD root
ENV PACKAGES="\
  bash \
  build-base \
  ca-certificates \
  dropbear \
  dumb-init \
  git \
  linux-headers \
  musl \
  openrc \
  openssh \
  openssh-server \
  py-setuptools \
  python2 \
  python2-dev \
  shadow \
  sudo \
  "

RUN \
  && apk --update add $PACKAGES \
  && sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
  && echo "root:${ROOT_PASSWORD}" | chpasswd \
  && rm -rf /var/cache/apk/* /tmp/*

COPY bin/ssh-entrypoint.sh /usr/local/bin/
EXPOSE 22
ENTRYPOINT ["ssh-entrypoint.sh"]