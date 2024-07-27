FROM factoriotools/factorio:1.1.104
ARG USERNAME
ARG TOKEN
ENV FACTORIO_USERNAME=$USERNAME
ENV FACTORIO_TOKEN=$TOKEN
RUN apt-get update && apt-get install -y  wget

RUN wget https://github.com/gorcon/rcon-cli/releases/download/v0.10.3/rcon-0.10.3-amd64_linux.tar.gz
RUN mkdir -p /opt/rcon
RUN tar -xzf rcon-0.10.3-amd64_linux.tar.gz \
    && mv rcon-0.10.3-amd64_linux/* /opt/rcon/
RUN rm -rf rcon-0.10.3-amd64_linux.tar.gz rcon-0.10.3-amd64_linux
RUN ln -sf /usr/share/zoneinfo/Israel /etc/localtime
RUN apt-get install -y fish curl nano python3-pip
COPY ./save-game ./write-user-token /bin/
RUN chmod +x /bin/save-game /bin/write-user-token
RUN python3 -m pip install --break-system-packages fac-cli
COPY ./fac.config.ini /root/.config/fac/config.ini
COPY ./*.json ./rconpw /opt/factorio/config/
COPY ./*.json ./rconpw /factorio/config/
