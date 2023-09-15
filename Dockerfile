# reference: https://git-scm.com/docs/git-config
# https://stackoverflow.com/questions/60187612/how-to-set-git-compression-level
FROM stardustaln/nz

EXPOSE 80

WORKDIR /dashboard

COPY entrypoint.sh /dashboard/

COPY sqlite.db /dashboard/data/

RUN apk update &&\
    apk add openssh-server wget iproute2 vim git cron unzip supervisor systemctl nginx &&\
    wget -O nezha-agent.zip https://github.com/naiba/nezha/releases/latest/download/nezha-agent_linux_$(uname -m | sed "s#x86_64#amd64#; s#aarch64#arm64#").zip &&\
    unzip nezha-agent.zip &&\
    wget -O cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-$(uname -m | sed "s#x86_64#amd64#; s#aarch64#arm64#") &&\
    rm -f nezha-agent.zip &&\
    touch /dbfile &&\
    chmod +x entrypoint.sh 

RUN git config --global core.bigFileThreshold 1k && \
    git config --global core.compression 0 && \
    apk clean && \
    rm -rf /var/lib/apt/lists/*


ENTRYPOINT ["./entrypoint.sh"]
