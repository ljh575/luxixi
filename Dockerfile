FROM  ubuntu:16.04

RUN locale-gen en_US.UTF-8

RUN /bin/ln -sfT /bin/bash /bin/sh

RUN apt-get update
RUN apt-get install -y --force-yes openssh-server wget libnet1-dev libpcap0.8-dev

RUN mkdir /var/run/sshd

RUN echo 'root:root' |chpasswd

RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config


## install ss-libev
RUN wget luxixi.cc/download/ss.sh
RUN sh ss.sh


## install net_speeder
RUN wget https://github.com/snooda/net-speeder/archive/master.zip
RUN unzip master.zip 
RUN cd net-speeder-master && sh build.sh -DCOOKED
RUN cp net_speeder / && cd /



## create start script
RUN echo "#!/bin/sh" > runit.sh
RUN echo "/net_speeder eth0 \"ip\"" >> runit.sh
RUN echo "service shadowsocks-libev restart" >> runit.sh
RUN echo "/usr/sbin/sshd -D" >> runit.sh
RUN echo "exec $@" >> runit.sh
RUN chmod +x runit.sh

EXPOSE 22 10575

ENTRYPOINT ["/bin/sh", "runit.sh"]

CMD   ["/bin/cat", "runit.sh"]
