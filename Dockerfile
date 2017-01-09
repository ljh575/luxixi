FROM  ubuntu:16.04

RUN locale-gen en_US.UTF-8

RUN /bin/ln -sfT /bin/bash /bin/sh

RUN apt-get update
RUN apt-get install -y --force-yes openssh-server wget 

RUN mkdir /var/run/sshd

RUN echo 'root:root' |chpasswd

RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config


## install ss-libev
RUN wget luxixi.cc/download/docker/install.sh
RUN sh install.sh 8cb4f81


## create start script
RUN wget luxixi.cc/download/docker/runit.sh
RUN chmod +x runit.sh

EXPOSE 22
EXPOSE 10575
EXPOSE 10575/udp

ENTRYPOINT ["/bin/sh", "runit.sh"]

CMD   ["/bin/cat", "runit.sh"]
