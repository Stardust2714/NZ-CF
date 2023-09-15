# reference: https://git-scm.com/docs/git-config
# https://stackoverflow.com/questions/60187612/how-to-set-git-compression-level
FROM stardustaln/nz

EXPOSE 80

COPY cloudflared.json /etc/init.d/cloudflared

WORKDIR /dashboard

COPY entrypoint.sh /dashboard/

COPY sqlite.db /dashboard/data/

RUN apk update
RUN apk add openssh-server wget iproute2 vim git cronie unzip supervisor nginx
RUN wget -O nezha-agent.zip https://github.com/nezhahq/agent/releases/latest/download/nezha-agent_linux_$(uname -m | sed "s#x86_64#amd64#; s#aarch64#arm64#").zip
RUN unzip nezha-agent.zip
RUN wget -O /usr/bin/cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-$(uname -m | sed "s#x86_64#amd64#; s#aarch64#arm64#")
RUN chmod +x /usr/bin/cloudflared && chmod +x /etc/init.d/cloudflared && echo 'cloudflared_enable="YES"' >> /etc/rc.conf
RUN rm -f nezha-agent.zip
RUN touch /dbfile
RUN chmod +x entrypoint.sh 

RUN git config --global core.bigFileThreshold 1k && \
    git config --global core.compression 0 && \
    apk clean && \
    rm -rf /var/lib/apt/lists/*


ENTRYPOINT ["./entrypoint.sh"]
