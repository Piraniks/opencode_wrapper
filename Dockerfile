FROM debian:13.5-slim

COPY setup.sh /setup.sh
RUN /setup.sh

ENV PIPX_BIN_DIR=/usr/local/bin
RUN pipx install poetry \
    && pipx install uv

RUN npm install -g opencode-ai@1.17.4

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

WORKDIR /workdir
CMD ["opencode"]
