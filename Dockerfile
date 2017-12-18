FROM alpine

# Some definitions
ENV SUDOFILE /etc/sudoers
ENV SSHKEYFILE vagrantssh.key
ENV USER vagrant

# Import the newly generated public key into the docker image
ADD keys/${SSHKEYFILE}.pub /tmp/${SSHKEYFILE}.pub
0f\80i 080lvf\hx
RUN \
  # Install the public key for root user
  cat /tmp/${SSHKEYFILE}.pub >> /root/.ssh/authorized_keys;                 \
  # Create user
  useradd                                                                   \
    --shell /bin/bash                                                       \
    --create-home                                                           \
    --base-dir /home                                                        \
    --user-group                                                            \
    --groups sudo,ssh                                                       \
    --password ''                                                           \
    ${USER};                                                                \
  # Install the public key for user
  mkdir -p /home/${USER}/.ssh;                                              \
  cat /tmp/${SSHKEYFILE}.pub >> /home/${USER}/.ssh/authorized_keys;         \
  chown -R ${USER}:${USER} /home/${USER}/.ssh;                              \
  # Remove the temporary location for the key
  rm -f /tmp/${SSHKEYFILE}.pub;                                             \
  # Update apt-cache, so that stuff can be installed
  apk update;                                                               \
  # Install python (otherwise ansible will not work)
  apk add python2-dev;                                                      \
  # Enable password-less sudo for all user (including the 'vagrant' use
  test -e ${SUDOFILE} || touch ${SUDOFILE};                                 \
  chmod u+w ${SUDOFILE};                                                    \
  echo '%sudo   ALL=(ALL:ALL) NOPASSWD: ALL' >> ${SUDOFILE};                \
  chmod u-w ${SUDOFILE}
