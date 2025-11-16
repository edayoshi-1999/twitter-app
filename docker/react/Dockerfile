# Node.js 20 Alpine ベースイメージ
FROM node:20-alpine

# 作業ディレクトリ設定
WORKDIR /app

# パッケージマネージャーの最新化
RUN npm install -g npm@latest

# node ユーザーに適切な権限を設定
RUN chown -R node:node /app

# node ユーザーで実行
USER node

# Vite 開発サーバーのポート公開
EXPOSE 5173

# デフォルトコマンド（package.jsonが存在する場合に実行）
# 実際の起動は docker-compose.yml でオーバーライド可能
CMD ["sh", "-c", "if [ -f package.json ]; then npm install && npm run dev; else echo 'Waiting for frontend project...'; tail -f /dev/null; fi"]
