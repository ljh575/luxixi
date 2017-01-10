FROM  ubuntu:14.04

ENV GITHUB  https://github.com/ljh575/luxixi/raw/master

RUN locale-gen en_US.UTF-8

RUN /bin/ln -sfT /bin/bash /bin/sh

RUN apt-get update
RUN apt-get install -y --force-yes openssh-server wget  git

RUN mkdir /var/run/sshd

RUN echo 'root:root' |chpasswd

RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config


RUN wget --no-check-certificate $GITHUB/script/install.sh && sh install.sh 8cb4f81
RUN wget --no-check-certificate $GITHUB/script/runit.sh && chmod +x runit.sh

EXPOSE 22
EXPOSE 10575
EXPOSE 10575/udp

ENTRYPOINT ["/bin/sh", "runit.sh"]

CMD   ["/bin/cat", "runit.sh"]
