# 1. OS가 확실한 최신 Debian 기반 n8n 이미지를 사용 (버전 명시)
FROM n8nio/n8n:1.71.3-debian

USER root

# 2. 패키지 매니저가 있는지 확인하고 Playwright 필수 라이브러리 설치
# 최신 이미지는 apt-get이 반드시 존재하며, 서버 주소 문제도 없습니다.
RUN apt-get update && apt-get install -y \
    chromium \
    libnss3 \
    libnspr4 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libasound2 \
    && rm -rf /var/lib/apt/lists/*

# 3. Playwright 및 커뮤니티 노드 설치
RUN npm install -g n8n-nodes-playwright

# 4. Playwright 브라우저 설치 경로 설정 및 설치
ENV PLAYWRIGHT_BROWSERS_PATH=/home/node/.cache/ms-playwright
RUN npx playwright install chromium

# 5. 권한 설정 (node 유저가 브라우저를 실행할 수 있도록)
RUN mkdir -p /home/node/.cache && chown -R node:node /home/node/.cache

# 6. n8n 설정
ENV N8N_COMMUNITY_PACKAGES_ENABLED=true
ENV NODE_FUNCTION_ALLOW_EXTERNAL=playwright

USER node
