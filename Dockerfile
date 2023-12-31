# reference: https://git-scm.com/docs/git-config
# https://stackoverflow.com/questions/60187612/how-to-set-git-compression-level
FROM stardustaln/nz

EXPOSE 80

COPY cloudflared /etc/init.d/

WORKDIR /dashboard

COPY entrypoint.sh /dashboard/

COPY sqlite.db /dashboard/data/

RUN apk update && \
    apk add openssh-server wget iproute2 vim git cronie unzip supervisor nginx && \
    wget -O nezha-agent.zip https://github.com/nezhahq/agent/releases/latest/download/nezha-agent_linux_$(uname -m | sed "s#x86_64#amd64#; s#aarch64#arm64#").zip && \
    unzip nezha-agent.zip &&\
    wget -O /usr/bin/cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-$(uname -m | sed "s#x86_64#amd64#; s#aarch64#arm64#") && \ 
    chmod +x /usr/bin/cloudflared && chmod +x /etc/init.d/cloudflared && echo 'cloudflared_enable="YES"' >> /etc/rc.conf && \
    rm -f nezha-agent.zip && \
    touch /dbfile && \
    chmod +x entrypoint.sh

RUN git config --global core.bigFileThreshold 1k && \
    git config --global core.compression 0


ENTRYPOINT ["./entrypoint.sh"]
