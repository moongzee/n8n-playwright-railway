FROM n8nio/n8n:latest

USER root

# 1. Debian Buster EOL 대응: 미러 서버를 archive 경로로 변경
RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list && \
    sed -i 's|security.debian.org/debian-security|archive.debian.org/debian-security|g' /etc/apt/sources.list && \
    sed -i '/buster-updates/d' /etc/apt/sources.list

# 2. 패키지 업데이트 및 Playwright 필수 의존성 설치
RUN apt-get update && apt-get install -y \
    curl \
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
    libpangocairo-1.0-0 \
    libpango-1.0-0 \
    && rm -rf /var/lib/apt/lists/*

# 3. 커뮤니티 노드 설치
RUN npm install -g n8n-nodes-playwright

# 4. Playwright 브라우저 설치
# root 권한으로 실행하되, 나중에 node 사용자가 쓸 수 있도록 경로 설정
ENV PLAYWRIGHT_BROWSERS_PATH=/home/node/.cache/ms-playwright
RUN npx playwright install chromium

# 5. 권한 수정 (Playwright 캐시 디렉토리를 node 유저가 쓸 수 있게 함)
RUN mkdir -p /home/node/.cache && chown -R node:node /home/node/.cache

# 6. 환경 변수 설정
ENV N8N_COMMUNITY_PACKAGES_ENABLED=true
ENV NODE_FUNCTION_ALLOW_EXTERNAL=playwright

USER node
