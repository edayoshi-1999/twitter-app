#!/bin/bash

# Twitter クローン開発環境起動スクリプト
# このスクリプトは、開発に必要なすべてのサービスと自動テストを起動します

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SESSION="twitter-dev"

echo "🚀 Twitter クローン開発環境を起動します..."
echo ""

# Docker Compose サービスを起動
echo "📦 Docker Compose サービスを起動中..."
cd "$PROJECT_ROOT"
docker-compose up -d

echo "⏳ サービスの起動を待機中..."
sleep 5

# Docker Compose サービスの状態を確認
echo ""
echo "✅ Docker Compose サービスの状態:"
docker-compose ps

echo ""
echo "🧪 自動テスト環境を起動します..."
echo ""

# tmux がインストールされているか確認
if ! command -v tmux &> /dev/null; then
    echo "⚠️  tmux がインストールされていません。"
    echo "   手動で以下のコマンドを別々のターミナルで実行してください："
    echo ""
    echo "   ターミナル1: docker-compose exec laravel composer dev:test"
    echo "   ターミナル2: docker-compose exec react npm run test:watch"
    echo ""
    exit 1
fi

# 既存のセッションがあれば削除
tmux kill-session -t $SESSION 2>/dev/null || true

# 新しいセッションを作成
echo "📺 tmux セッション '$SESSION' を作成中..."
tmux new-session -d -s $SESSION -n "Backend-Test"

# ウィンドウ1: Laravel 自動テスト
echo "   - ウィンドウ1: Laravel 自動テスト"
tmux send-keys -t $SESSION:0 "cd $PROJECT_ROOT && docker-compose exec laravel composer dev:test" C-m

# ウィンドウ2: React 自動テスト（将来的に使用）
# echo "   - ウィンドウ2: React 自動テスト"
# tmux new-window -t $SESSION:1 -n "Frontend-Test"
# tmux send-keys -t $SESSION:1 "cd $PROJECT_ROOT && docker-compose exec react npm run test:watch" C-m

# ウィンドウ2: Laravel サーバーログ
echo "   - ウィンドウ2: Laravel ログ"
tmux new-window -t $SESSION:1 -n "Logs"
tmux send-keys -t $SESSION:1 "cd $PROJECT_ROOT && docker-compose logs -f laravel" C-m

# ウィンドウ3: 一般的なシェル
echo "   - ウィンドウ3: シェル"
tmux new-window -t $SESSION:2 -n "Shell"
tmux send-keys -t $SESSION:2 "cd $PROJECT_ROOT" C-m

echo ""
echo "✨ 開発環境が起動しました！"
echo ""
echo "📝 tmux の使い方:"
echo "   - Ctrl+b → 0   : Laravel テスト画面に移動"
echo "   - Ctrl+b → 1   : ログ画面に移動"
echo "   - Ctrl+b → 2   : シェル画面に移動"
echo "   - Ctrl+b → d   : デタッチ（バックグラウンドで実行継続）"
echo "   - tmux attach -t $SESSION : 再アタッチ"
echo "   - Ctrl+C       : 各ウィンドウで実行中のプロセスを停止"
echo ""
echo "🛑 開発環境を停止するには:"
echo "   - tmux kill-session -t $SESSION"
echo "   - docker-compose down"
echo ""

# セッションにアタッチ
tmux attach-session -t $SESSION
