FROM centos:7

# Some definitions
ENV SUDOFILE /etc/sudoers
ENV SSHKEYFILE vagrantssh.key

# Import the newly generated public key into the docker image
ADD keys/${SSHKEYFILE}.pub /tmp/${SSHKEYFILE}.pub

# Install systemd -- See https://hub.docker.com/_/centos/
# -----------------
# Replace fake systemd with real systemd
# Lifted from http://jperrin.github.io/centos/2014/09/25/centos-docker-and-systemd/
RUN yum -y swap -- remove fakesystemd -- install systemd systemd-libs initscripts
RUN yum -y update --quiet; yum clean all; \
	(cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
	rm -f /lib/systemd/system/multi-user.target.wants/*; \
	rm -f /etc/systemd/system/*.wants/*; \
	rm -f /lib/systemd/system/local-fs.target.wants/*; \
	rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
	rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
	rm -f /lib/systemd/system/basic.target.wants/*; \
	rm -f /lib/systemd/system/anaconda.target.wants/*;

RUN yum -y -q install epel-release
RUN yum -y -q install git ansible sudo python openssh-server openssh-clients hostname

RUN \
  cat /tmp/${SSHKEYFILE}.pub >> /root/.ssh/authorized_keys; \
  useradd \
    --shell /bin/bash \
    --create-home \
    --base-dir /home \
    --user-group \
    --groups sudo,ssh \
    --password '' \
    vagrant; \
  # Install the public key for vagrant user
  mkdir -p /home/vagrant/.ssh && \
  cat /tmp/${SSHKEYFILE}.pub >> /home/vagrant/.ssh/authorized_keys && \
  chown -R vagrant:vagrant /home/vagrant/.ssh && \
  # Remove the temporary location for the key
  rm -f /tmp/${SSHKEYFILE}.pub && \
	useradd --create-home -s /bin/bash vagrant; \
	echo -n 'vagrant:vagrant' | chpasswd; \
	echo 'vagrant ALL = NOPASSWD: ALL' > /etc/sudoers.d/vagrant; \
	chmod 440 /etc/sudoers.d/vagrant; \
	mkdir -p /home/vagrant/.ssh; \
	chmod 700 /home/vagrant/.ssh; \
	chown -R vagrant:vagrant /home/vagrant/.ssh; \
	sed -i -e 's/Defaults.*requiretty/#&/' /etc/sudoers; \
	sed -i -e 's/\(UsePAM \)yes/\1 no/' /etc/ssh/sshd_config; \
	echo -e '[local]\nlocalhost ansible_connection=local' > /etc/ansible/hosts; \
	systemctl enable sshd.service;

CMD ["/usr/sbin/init"]





# RUN \
#   # Install the public key for root user
#   cat /tmp/${SSHKEYFILE}.pub >> /root/.ssh/authorized_keys && \
#   # Create vagrant user
#   useradd \
#     --shell /bin/bash \
#     --create-home \
#     --base-dir /home \
#     --user-group \
#     --groups sudo,ssh \
#     --password '' \
#     vagrant && \
#   # Install the public key for vagrant user
#   mkdir -p /home/vagrant/.ssh && \
#   cat /tmp/${SSHKEYFILE}.pub >> /home/vagrant/.ssh/authorized_keys && \
#   chown -R vagrant:vagrant /home/vagrant/.ssh && \
#   # Remove the temporary location for the key
#   rm -f /tmp/${SSHKEYFILE}.pub && \
#   # Update apt-cache, so that stuff can be installed
#   apt-get -y update && \
#   # Install python (otherwise ansible will not work)
#   # Install aptitude, since ansible needs it (only apt-get is installed)
#   apt-get -y install aptitude python sudo && \
#   # Enable password-less sudo for all user (including the 'vagrant' user)
#   test -e ${SUDOFILE} || touch ${SUDOFILE} && \
#   chmod u+w ${SUDOFILE} && \
#   echo '%sudo   ALL=(ALL:ALL) NOPASSWD: ALL' >> ${SUDOFILE} && \
#   chmod u-w ${SUDOFILE}

