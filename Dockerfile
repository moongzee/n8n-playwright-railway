FROM n8nio/n8n:latest

USER root

# Playwright OS dependencies
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont

# 커뮤니티 노드 설치
RUN npm install -g n8n-nodes-playwright

# Playwright browser install
RUN npx playwright install chromium

# 커뮤니티 노드 허용
ENV N8N_COMMUNITY_PACKAGES_ENABLED=true
ENV NODE_FUNCTION_ALLOW_EXTERNAL=playwright
ENV PLAYWRIGHT_BROWSERS_PATH=/usr/bin

USER node