FROM debian:13.7-slim

COPY setup.sh /setup.sh
RUN /setup.sh

ENV PIPX_BIN_DIR=/usr/local/bin PIPX_HOME=/usr/local/share/pipx
ENV XDG_DATA_HOME=/opencode_data
RUN pipx install poetry && pipx install uv
RUN uv python install 3.15 3.14

ENV OPENCODE_DISABLE_AUTOUPDATE=1
RUN npm install -g @opencode/cli@2.2.6

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

WORKDIR /workdir
CMD ["opencode"]

