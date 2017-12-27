FROM jdeathe/centos-ssh:centos-7-2.2.4

RUN yum -y swap -- remove fakesystemd -- install systemd systemd-libs
