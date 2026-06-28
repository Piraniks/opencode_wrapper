FROM node:23.6.0-bookworm-slim

ENV PATH="/root/.local/bin:${PATH}"

COPY setup.sh /setup.sh
RUN /setup.sh

RUN pipx install poetry \
    && pipx install uv

RUN npm install -g opencode-ai@1.17.4

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

WORKDIR /workdir
CMD ["opencode"]
