FROM centos:7
MAINTAINER zipsan <zipsan@mail.zipsan.pw>

RUN yum update -y && \
    yum upgrade -y && \
    yum clean all -y && \
    yum install -y https://centos7.iuscommunity.org/ius-release.rpm && \
    rm -rf /var/cache/yum/*

RUN yum install -y \
    createrepo \
    bzip2 \
    busybox \
    nginx && \
    yum clean all -y && \
    rm -rf /var/cache/yum/*

RUN mkdir /security
RUN createrepo /security
RUN echo \
    "[security]"\n \
    "name=CentOS-$releasever - Security"\n \
    "baseurl=file:///security"\n \
    >> /etc/yum.repos.d/CentOS-Base.repo

WORKDIR /security
RUN curl https://raw.githubusercontent.com/vmfarms/generate_updateinfo/master/generate_updateinfo.py -O

RUN mkdir /opt/centos-security
WORKDIR /opt/centos-security
COPY ./update.sh /opt/centos-security/update.sh
RUN /bin/bash ./update.sh
COPY ./crontab /var/spool/cron/crontabs/root

WORKDIR /opt/centos-security
RUN curl -o busybox https://busybox.net/downloads/binaries/1.28.1-defconfig-multiarch/busybox-x86_64 && chmod +x ./busybox
ENV TZ=Asia/Tokyo
RUN localedef -i ja_JP -c -f UTF-8 -A /usr/share/locale/locale.alias ja_JP.UTF-8

RUN sed -i -e "s/\/usr\/share\/nginx\/html/\/security/g" /etc/nginx/nginx.conf
RUN sed -i -e "s/error.log;/error.log;\nerror_log \/dev\/stdout;/g" /etc/nginx/nginx.conf
RUN sed -i -e "s/access.log  main;/access.log  main;\    access_log \/dev\/stdout  main;/g" /etc/nginx/nginx.conf
RUN sed -i -e "s/http {/http {\n    server_tokens off;\n    autoindex on;\n    autoindex_exact_size off;\n    autoindex_localtime on;/g" /etc/nginx/nginx.conf

RUN echo "daemon off;" >> /etc/nginx/nginx.conf

RUN ./busybox crond -b -L /dev/stderr > /var/log/crond.log

CMD ["/usr/sbin/nginx"]

