FROM debian:stable-slim
MAINTAINER fcying

RUN echo "deb http://mirrors.ustc.edu.cn/debian stable main" > /etc/apt/sources.list

ENV DEBIAN_FRONTEND noninteractive
ENV VER 2.6.1
RUN apt-get update && apt-get upgrade \
    && apt-get install -y vim wget mongo-tools \
        wkhtmltopdf xvfb ttf-freefont fontconfig dbus psmisc \
    # for leanote mongo setting
    && mkdir -p /Users/life/Desktop/hadoop/mongodb-osx-x86_64-2.4.7/bin \
    && ln -sf /usr/bin/mongodump /Users/life/Desktop/hadoop/mongodb-osx-x86_64-2.4.7/bin \
    && ln -sf /usr/bin/mongorestore /Users/life/Desktop/hadoop/mongodb-osx-x86_64-2.4.7/bin \
    # leanote binary
    && mkdir leanote && cd leanote \
    && wget https://sourceforge.net/projects/leanote-bin/files/${VER}/leanote-linux-amd64-v${VER}.bin.tar.gz/download \
    && tar xzvf download && rm download \
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
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY init /
RUN chmod 770 /init

ENTRYPOINT ["/init"]
