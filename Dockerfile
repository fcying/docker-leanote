FROM debian:stretch-slim
MAINTAINER fcying

ENV DEBIAN_FRONTEND noninteractive
RUN echo "deb http://ftp.cn.debian.org/debian stretch main" > /etc/apt/sources.list \
    && apt-get update && apt-get upgrade -y \
    && apt-get install -y daemontools vim wget cron gnupg psmisc unzip \
        wkhtmltopdf xvfb ttf-freefont fontconfig \
    #go 1.16.3
    && wget -O go.tgz https://golang.org/dl/go1.16.3.linux-amd64.tar.gz \
    && tar xzf go.tgz -C /usr/local/ && rm -rf go.tgz \
    && ln -svf /usr/local/go/bin/go /usr/local/bin/ \
    && ln -svf /usr/local/go/bin/gofmt /usr/local/bin/ \
    # mongodb 3.6
    && echo "deb http://repo.mongodb.org/apt/debian stretch/mongodb-org/3.6 main" >> /etc/apt/sources.list \
    && apt-key adv --keyserver hkp://keyserver.Ubuntu.com:80 --recv 58712A2291FA4AD5 \
    && apt-get update \
    && apt-get install -y mongodb-org-tools mongodb-org-server \
    # for leanote mongodb setting
    && mkdir -p /Users/life/Desktop/hadoop/mongodb-osx-x86_64-2.4.7/bin \
    && ln -sf /usr/bin/mongodump /Users/life/Desktop/hadoop/mongodb-osx-x86_64-2.4.7/bin \
    && ln -sf /usr/bin/mongorestore /Users/life/Desktop/hadoop/mongodb-osx-x86_64-2.4.7/bin \
    # leanote binary
    && mkdir /leanote && cd /leanote \
    && wget https://github.com/coocn-cn/leanote/archive/refs/heads/master.zip \
    && unzip master.zip && rm master.zip \
    && cd leanote-master/assets/build && ./build.sh \
    && mv output/leanote /leanote/ \
    && rm -rf /leanote/leanote-master \
    && rm -rf /usr/local/go && rm -rf ~/go \
    # Chinese fonts
    && apt-get install -y \
        fonts-arphic-bkai00mp \
        fonts-arphic-bsmi00lp \
        fonts-arphic-gbsn00lp \
        fonts-arphic-gkai00mp \
        fonts-arphic-ukai \
        fonts-arphic-uming \
        ttf-wqy-zenhei \
        ttf-wqy-microhei \
        xfonts-wqy \
    && fc-cache \
    # Wrapper for xvfb
    && mv /usr/bin/wkhtmltopdf /usr/bin/wkhtmltopdf-origin \
    && \
    echo '#!/usr/bin/env sh\n\
Xvfb :10 -screen 0 1024x768x24 -ac +extension GLX +render -noreset & \n\
DISPLAY=:10.0 wkhtmltopdf-origin $@ \n\
killall Xvfb\
' > /usr/local/bin/wkhtmltopdf \
    && chmod +x /usr/local/bin/wkhtmltopdf \
    && useradd -u 911 -U -G users -d /leanote -s /bin/bash abc \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY init /
COPY run.sh /
COPY crontab /leanote
RUN chmod +x /init /run.sh

ENTRYPOINT ["/init"]
