# 開発スクリプト

このディレクトリには、開発を効率化するためのスクリプトが含まれています。

## 📜 利用可能なスクリプト

### `dev.sh` - 統合開発環境起動

**機能**:
- Docker Compose サービスを起動
- Laravel の自動テストを起動（ファイル監視モード）
- tmux で複数のウィンドウを管理
- ログをリアルタイムで確認

**使用方法**:

```bash
# プロジェクトルートから実行
./scripts/dev.sh
```

**tmux の操作**:
- `Ctrl+b` → `0` : Laravel テスト画面に移動
- `Ctrl+b` → `1` : ログ画面に移動
- `Ctrl+b` → `2` : シェル画面に移動
- `Ctrl+b` → `d` : デタッチ（バックグラウンドで実行継続）
- `tmux attach -t twitter-dev` : 再アタッチ

**停止方法**:

```bash
# tmux セッションを終了
tmux kill-session -t twitter-dev

# Docker サービスを停止
docker-compose down
```

---

## 🚀 クイックスタート

### 1. 初回セットアップ

```bash
# Docker Compose サービスを起動
docker-compose up -d

# データベースをマイグレーション
docker-compose exec laravel php artisan migrate
docker-compose exec laravel php artisan migrate --env=testing
```

### 2. 開発環境の起動

**オプション1: tmux統合スクリプト（推奨）**

```bash
./scripts/dev.sh
```

**オプション2: 手動で各サービスを起動**

ターミナル1（Laravel自動テスト）:
```bash
docker-compose exec laravel composer dev:test
```

ターミナル2（ログ）:
```bash
docker-compose logs -f laravel
```

### 3. 開発サイクル

1. コードを編集
2. ファイルを保存
3. 自動的にテストが実行される
4. テスト結果を確認
5. 必要に応じて修正

---

## 📝 Composer スクリプト

`backend/composer.json` に定義されているスクリプト：

### テスト関連

```bash
# すべてのテストを実行
docker-compose exec laravel composer test

# 自動テスト（ファイル監視モード）
docker-compose exec laravel composer test:watch
docker-compose exec laravel composer dev:test  # エイリアス

# ツイート機能のテストのみ
docker-compose exec laravel composer test:tweets

# カバレッジ付きテスト
docker-compose exec laravel composer test:coverage
```

### コード品質

```bash
# コードスタイルチェック
docker-compose exec laravel composer lint

# コードスタイル自動修正
docker-compose exec laravel composer lint:fix
```

---

## 🔧 VS Code 統合

`.vscode/tasks.json` に以下のタスクが定義されています：

**使用方法**:
1. `Ctrl+Shift+P` → `Tasks: Run Task`
2. 実行したいタスクを選択

**利用可能なタスク**:
- 🧪 Laravel: Watch Tests（自動テスト）
- ✅ Laravel: Run Tests（テスト実行）
- 📊 Laravel: Test Coverage（カバレッジ）
- 🐦 Laravel: Test Tweets Only（ツイートテストのみ）
- 🎨 Laravel: Lint Code（コードスタイルチェック）
- 🔧 Laravel: Fix Code Style（自動修正）
- 🚀 Dev: Start All Services（統合起動）
- 🐳 Docker: Start Services（Docker起動）
- 🛑 Docker: Stop Services（Docker停止）

---

## 💡 開発のヒント

### TDD ワークフロー

```bash
# 1. ファイル監視モードでテストを起動
docker-compose exec laravel composer dev:test

# 2. 新しいテストを書く（Red）
# tests/Feature/Tweet/TweetTest.php を編集

# 3. テストが失敗することを確認（保存すると自動実行）

# 4. 実装を書く（Green）
# app/Http/Controllers/TweetController.php を編集

# 5. テストが成功することを確認（保存すると自動実行）

# 6. リファクタリング（Refactor）
# コードを整理・最適化
```

### デバッグ

```bash
# Laravel のログをリアルタイムで表示
docker-compose logs -f laravel

# 特定のテストのみデバッグ実行
docker-compose exec laravel ./vendor/bin/pest --filter="認証済みユーザーはツイートを投稿できる"

# 詳細な出力
docker-compose exec laravel ./vendor/bin/pest --verbose
```

---

## 📚 参考リンク

- [Pest Documentation](https://pestphp.com)
- [tmux Cheat Sheet](https://tmuxcheatsheet.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

---

**最終更新日**: 2025-11-16
