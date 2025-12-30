# 1. 패키지 설치가 가능한 표준 Node.js Debian 이미지 사용
FROM node:20-bookworm-slim

USER root

# 2. Playwright 및 Chromium 실행에 필요한 OS 필수 라이브러리 설치
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

# 3. n8n 설치
RUN npm install -g n8n

# 4. Playwright 노드 설치 (중요: --ignore-scripts를 추가하여 pnpm 강제 체크를 무시합니다)
RUN npm install -g n8n-nodes-playwright --ignore-scripts

# 5. Playwright 브라우저(Chromium) 설치 및 경로 설정
ENV PLAYWRIGHT_BROWSERS_PATH=/home/node/.cache/ms-playwright
# install-deps를 통해 한번 더 의존성을 체크합니다.
RUN npx playwright install --with-deps chromium

# 6. n8n 작업 디렉토리 및 권한 설정
WORKDIR /home/node/.n8n
RUN mkdir -p /home/node/.cache && chown -R node:node /home/node

# 7. 환경 변수 설정
ENV N8N_COMMUNITY_PACKAGES_ENABLED=true
ENV NODE_FUNCTION_ALLOW_EXTERNAL=playwright
EXPOSE 5678

USER node

# 8. n8n 실행
CMD ["n8n", "start"]
