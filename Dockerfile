FROM n8nio/n8n:latest

USER root

# Playwright 및 브라우저 실행을 위한 OS 의존성 설치 (Debian/Ubuntu 방식)
RUN apt-get update && apt-get install -y \
    chromium \
    libnss3 \
    libfreetype6 \
    libharfbuzz0b \
    ca-certificates \
    fonts-freefont-ttf \
    libgbm1 \
    libasound2 \
    && rm -rf /var/lib/apt/lists/*

# 커뮤니티 노드 설치
RUN npm install -g n8n-nodes-playwright

# Playwright 브라우저 설치 (의존성 포함)
RUN npx playwright install chromium

# 커뮤니티 노드 허용 및 환경 변수 설정
ENV N8N_COMMUNITY_PACKAGES_ENABLED=true
ENV NODE_FUNCTION_ALLOW_EXTERNAL=playwright
# Railway 환경에서는 경로 설정이 중요할 수 있습니다.
ENV PLAYWRIGHT_BROWSERS_PATH=/home/node/.cache/ms-playwright 

USER node
