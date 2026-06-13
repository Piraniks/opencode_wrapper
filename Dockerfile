FROM node:26-bookwork-slim

RUN apt update \
    && apt install -y --no-install-recommends ca-certificates curl gnupg  \
    && install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc \
    && chmod a+r /etc/apt/keyrings/docker.asc \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian bookworm stable" > /etc/apt/sources.list.d/docker.list \
    && apt update  \
    && apt install -y --no-install-recommends docker-ce docker-ce-cli containerd.io docker-compose-plugin

RUN apt update  \
    && apt install -y --no-install-recommends git jq ripgrep less python3 python3-pip

RUN npm install -g opencode-ai@1.17.4

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x ./entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["opencode"]
