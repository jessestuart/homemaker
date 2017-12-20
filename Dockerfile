FROM alpine:latest as ssh-builder

  # bash \
  # build-base \
  # ca-certificates \
  # dumb-init \
  # git \
  # linux-headers \
  # musl \
  # python2 \
  # shadow \
  # openssh-server \
ENV ROOT_PASSWORD root
ENV PACKAGES="\
bash \
openssh \
py-setuptools \
python2-dev \
sudo \
"

RUN apk --update add $PACKAGES \
		&& sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
		&& echo "root:${ROOT_PASSWORD}" | chpasswd \
		&& rm -rf /var/cache/apk/* /tmp/*

COPY bin/ssh-entrypoint.sh /usr/local/bin/

EXPOSE 22

ENTRYPOINT ["ssh-entrypoint.sh"]

# FROM ssh-builder

# ENV PACKAGES="\
#   bash \
#   build-base \
#   ca-certificates \
#   dumb-init \
#   git \
#   linux-headers \
#   musl \
#   openssh \
#   openssh-server \
#   py-setuptools \
#   python2 \
#   python2-dev \
#   shadow \
#   sudo \
#   "

# RUN apk update && apk upgrade && apk add $PACKAGES \
#       && rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

# # enable ssh
# RUN rm -f /etc/service/sshd/down \
# && mkdir /var/run/sshd \
# &&  ssh-keygen -f   /etc/ssh/ssh_host_rsa_key     -N '' -t rsa     \
# &&  ssh-keygen -f   /etc/ssh/ssh_host_dsa_key     -N '' -t dsa     \
# &&  ssh-keygen -f   /etc/ssh/ssh_host_ecdsa_key   -N '' -t ecdsa   \
# &&  ssh-keygen -f   /etc/ssh/ssh_host_ed25519_key -N '' -t ed25519 \
# &&  cp -a /etc/ssh  /etc/ssh.default \
# &&  chmod 0600      /etc/ssh/*

# RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# RUN echo 'root:root' | chpasswd

# EXPOSE 22 2222 2200

# # ENTRYPOINT ["/usr/bin/dumb-init"]
# CMD ["/usr/sbin/sshd", "-D"]
