FROM itzg/minecraft-server:latest
ENV EULA=TRUE
ENV UID=5781
ENV GID=5781
RUN ln -sf /usr/share/zoneinfo/Israel /etc/localtime
COPY ./server.properties ./*.json /data/
COPY ./universal-graves /data/config/
