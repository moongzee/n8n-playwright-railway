# 1. OS가 확실한 Debian 기반 이미지를 사용합니다.
FROM n8nio/n8n:latest-debian

USER root

# 2. 필수 도구 설치 및 Playwright 시스템 의존성 자동 설치
# npx playwright install-deps는 해당 OS에 필요한 모든 라이브러리를 자동으로 찾아 설치합니다.
RUN apt-get update && apt-get install -y curl \
    && npx playwright install-deps chromium \
    && rm -rf /var/lib/apt/lists/*

# 3. n8n 커뮤니티 노드 설치
RUN npm install -g n8n-nodes-playwright

# 4. Playwright 브라우저(Chromium) 설치
RUN npx playwright install chromium

# 5. 환경 변수 설정
ENV N8N_COMMUNITY_PACKAGES_ENABLED=true
ENV NODE_FUNCTION_ALLOW_EXTERNAL=playwright
# n8n-nodes-playwright가 브라우저를 찾을 수 있도록 경로 설정
ENV PLAYWRIGHT_BROWSERS_PATH=/home/node/.cache/ms-playwright

USER node
