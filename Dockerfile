# 1. 패키지 설치가 가능한 표준 Node.js Debian 이미지를 베이스로 사용합니다.
FROM node:20-bookworm-slim

USER root

# 2. Playwright 및 Chromium 실행에 필요한 OS 필수 라이브러리 설치
# Debian Bookworm 환경이므로 apt-get이 정상 작동합니다.
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    fonts-freefont-ttf \
    libnss3 \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdrm2 \
    libgbm1 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libxkbcommon0 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    && rm -rf /var/lib/apt/lists/*

# 3. n8n과 Playwright 노드 설치
# n8n을 전역 설치하여 공식 이미지와 동일하게 작동하도록 합니다.
RUN npm install -g n8n n8n-nodes-playwright

# 4. Playwright 브라우저(Chromium) 설치 및 경로 설정
ENV PLAYWRIGHT_BROWSERS_PATH=/home/node/.cache/ms-playwright
RUN npx playwright install chromium

# 5. n8n 작업 디렉토리 및 권한 설정
WORKDIR /home/node/.n8n
RUN chown -R node:node /home/node

# 6. 환경 변수 설정
ENV N8N_COMMUNITY_PACKAGES_ENABLED=true
ENV NODE_FUNCTION_ALLOW_EXTERNAL=playwright
# Railway 환경에서 포트 바인딩을 위해 필요합니다.
EXPOSE 5678

USER node

# 7. n8n 실행
CMD ["n8n", "start"]
