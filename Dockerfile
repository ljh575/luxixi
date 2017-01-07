FROM  ubuntu:16.04

RUN locale-gen en_US.UTF-8

RUN /bin/ln -sfT /bin/bash /bin/sh

RUN apt-get update
RUN apt-get install -y --force-yes openssh-server wget

RUN mkdir /var/run/sshd

RUN echo 'root:root' |chpasswd

RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config


RUN wget luxixi.cc/download/ss.sh
RUN sh ss.sh

EXPOSE 10575

RUN /etc/init.d/shadowsocks-libev restart

EXPOSE 22

CMD    ["/usr/sbin/sshd", "-D"]
