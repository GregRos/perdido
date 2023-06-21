FROM factoriotools/factorio:1.1.80
RUN wget https://github.com/gorcon/rcon-cli/releases/download/v0.10.3/rcon-0.10.3-amd64_linux.tar.gz
RUN mkdir -p /opt/rcon
RUN tar -xzf rcon-0.10.3-amd64_linux.tar.gz \
    && mv rcon-0.10.3-amd64_linux/* /opt/rcon/
RUN rm -rf rcon-0.10.3-amd64_linux.tar.gz rcon-0.10.3-amd64_linux

RUN ln -sf /usr/share/zoneinfo/Israel /etc/localtime
COPY ./*.json ./rconpw /opt/factorio/config/
COPY ./save-game /bin/
RUN chmod +x /bin/save-game

