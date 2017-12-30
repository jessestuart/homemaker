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

RUN yum -y -q install epel-release
RUN yum -y -q install git ansible sudo python openssh-server openssh-clients hostname


RUN \
	useradd --create-home -s /bin/bash vagrant; \
	echo -n 'vagrant:vagrant' | chpasswd; \
	echo 'vagrant ALL = NOPASSWD: ALL' > /etc/sudoers.d/vagrant; \
	chmod 440 /etc/sudoers.d/vagrant; \
	mkdir -p /home/vagrant/.ssh; \
	chmod 700 /home/vagrant/.ssh; \
	echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key" > /home/vagrant/.ssh/authorized_keys; \
	chmod 600 /home/vagrant/.ssh/authorized_keys; \
	chown -R vagrant:vagrant /home/vagrant/.ssh; \
	sed -i -e 's/Defaults.*requiretty/#&/' /etc/sudoers; \
	sed -i -e 's/\(UsePAM \)yes/\1 no/' /etc/ssh/sshd_config; \
	echo -e '[local]\nlocalhost ansible_connection=local' > /etc/ansible/hosts; \
	systemctl enable sshd.service;

CMD ["/usr/sbin/init"]
