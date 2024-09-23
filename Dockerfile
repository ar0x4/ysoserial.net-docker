FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y wget mono-complete gnupg2 unzip software-properties-common file

RUN wget -nc https://dl.winehq.org/wine-builds/winehq.key \
    && apt-key add winehq.key \
    && apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main' \
    && apt-get update \
    && apt-get install -y --install-recommends winehq-stable 

RUN wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
    && chmod +x winetricks \
    && mv winetricks /usr/local/bin \
    && /usr/local/bin/winetricks --self-update

RUN /usr/local/bin/winetricks -q dotnet48

ADD https://api.github.com/repos/pwntester/ysoserial.net/releases/latest latest_release.json
RUN wget $(wget -q -O - https://api.github.com/repos/pwntester/ysoserial.net/releases/latest | grep -oP '(?<="browser_download_url": ").*ysoserial-.*\.zip') -O ysoserial.zip \
    && unzip ysoserial.zip -d ysoserial

RUN echo 'alias ysoserial="WINEDEBUG=-all wine /ysoserial/Release/ysoserial.exe"' >> ~/.bashrc

SHELL ["/bin/bash", "-c"]
