FROM centos:7

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

RUN yum -y --quiet install epel-release
RUN yum -y --quiet install git ansible sudo python openssh-server openssh-clients hostname

VOLUME ["/sys/fs/cgroup"]

RUN \
  useradd --create-home -s /bin/bash vagrant; \
  echo -n 'vagrant:vagrant' | chpasswd; \
  echo 'vagrant ALL = NOPASSWD: ALL' > /etc/sudoers.d/vagrant; \
  chmod 440 /etc/sudoers.d/vagrant; \
  mkdir -p /home/vagrant/.ssh; \
  chmod 700 /home/vagrant/.ssh;

RUN \
  echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key" > /home/vagrant/.ssh/authorized_keys; \
  chmod 600 /home/vagrant/.ssh/authorized_keys; \
  chown -R vagrant:vagrant /home/vagrant/.ssh; \
  sed -i -e 's/Defaults.*requiretty/#&/' /etc/sudoers; \
  sed -i -e 's/\(UsePAM \)yes/\1 no/' /etc/ssh/sshd_config; \
  echo -e '[local]\nlocalhost ansible_connection=local' > /etc/ansible/hosts; \
  systemctl enable sshd.service;

# RUN sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/' /etc/sudoers
# RUN echo -e '[local]\nlocalhost ansible_connection=local' > /etc/ansible/hosts
CMD ["/usr/sbin/init"]



# Docker image to use with Vagrant
# Aims to be as similar to normal Vagrant usage as possible
# Adds Puppet, SSH daemon
# RUN yum -y install http://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
# RUN yum -y install puppet-agent hostname
# Add vagrant user and key
# RUN useradd --create-home -s /bin/bash vagrant
# RUN echo -n 'vagrant:vagrant' | chpasswd
# RUN echo 'vagrant ALL = NOPASSWD: ALL' > /etc/sudoers.d/vagrant
# RUN chmod 440 /etc/sudoers.d/vagrant
# RUN mkdir -p /home/vagrant/.ssh
# RUN chmod 700 /home/vagrant/.ssh

# RUN echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key" > /home/vagrant/.ssh/authorized_keys
# RUN chmod 600 /home/vagrant/.ssh/authorized_keys
# RUN chown -R vagrant:vagrant /home/vagrant/.ssh
# RUN sed -i -e 's/Defaults.*requiretty/#&/' /etc/sudoers
# RUN sed -i -e 's/\(UsePAM \)yes/\1 no/' /etc/ssh/sshd_config
# RUN systemctl enable sshd.service
# CMD ["/usr/sbin/init"]
