FROM ghcr.io/openclaw/openclaw:2026.10.3

USER root

ENV NODE_ENV=production
ENV NPM_CONFIG_PREFIX=/data/npm
ENV NPM_CONFIG_CACHE=/data/npm-cache
ENV PNPM_HOME=/data/pnpm
ENV PNPM_STORE_DIR=/data/pnpm-store
ENV PATH="/data/npm/bin:/data/pnpm:${PATH}"

WORKDIR /railway-wrapper

COPY package.json ./
RUN npm install --omit=dev && npm cache clean --force
COPY src ./src

EXPOSE 8080

ENTRYPOINT ["tini", "--"]
CMD ["sh", "-lc", "if [ -f /data/.openclaw/agents/main/sessions/sessions.json ]; then openclaw doctor --session-sqlite import --session-sqlite-store /data/.openclaw/agents/main/sessions/sessions.json --yes; fi; exec node src/server.js"]
