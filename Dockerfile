FROM alpine
LABEL author="Jesse Stuart <hi@jessestuart.com"

# Install needed packages. Notes:
#   * dumb-init: a proper init system for containers, to reap zombie children
#   * musl: standard C library
#   * linux-headers: commonly needed, and an unusual package name from Alpine.
#   * build-base: used so we include the basic development packages (gcc)
#   * bash: so we can access /bin/bash
#   * git: to ease up clones of repos
#   * ca-certificates: for SSL verification during Pip and easy_install
#   * python: the binaries themselves
#   * python-dev: are used for gevent e.g.
#   * py-setuptools: required only in major version 2, installs easy_install so we can install Pip.
ENV PACKAGES="\
  dumb-init \
  musl \
  linux-headers \
  build-base \
  bash \
  git \
  ca-certificates \
  python2 \
  python2-dev \
  py-setuptools \
  shadow \
  openssh \
"


# Some definitions
ENV SUDOFILE /etc/sudoers
ENV SSHKEYFILE vagrantssh.key
ENV USER vagrant

# Import the newly generated public key into the docker image
ADD keys/${SSHKEYFILE}.pub /tmp/${SSHKEYFILE}.pub

RUN \
  echo; \
  echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" > /etc/apk/repositories; \
  echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories; \
  echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories; \
  # Update apt-cache, so that stuff can be installed
  apk update;                                                               \
  # Install python (otherwise ansible will not work)
  apk add --no-cache $PACKAGES;                                             \
# Install the public key for root user
  mkdir -p /root/.ssh/;                                                     \
  cat /tmp/${SSHKEYFILE}.pub >> /root/.ssh/authorized_keys;                 \
# # Create user
# useradd                                                                   \
#   --shell /bin/bash                                                       \
#   --create-home                                                           \
#   --base-dir /home                                                        \
#   --user-group                                                            \
#   --groups sudo,ssh                                                       \
#   --password ''                                                           \
#   ${USER};                                                                \
# # Install the public key for user
# mkdir -p /home/${USER}/.ssh;                                              \
# cat /tmp/${SSHKEYFILE}.pub >> /home/${USER}/.ssh/authorized_keys;         \
# chown -R ${USER}:${USER} /home/${USER}/.ssh;                              \
# # Remove the temporary location for the key
# rm -f /tmp/${SSHKEYFILE}.pub;                                             \
# # Enable password-less sudo for all user (including the 'vagrant' use
# test -e ${SUDOFILE} || touch ${SUDOFILE};                                 \
# chmod u+w ${SUDOFILE};                                                    \
# echo '%sudo   ALL=(ALL:ALL) NOPASSWD: ALL' >> ${SUDOFILE};                \
# chmod u-w ${SUDOFILE};

ENTRYPOINT ["/usr/bin/dumb-init"]
CMD ["/bin/bash"]
