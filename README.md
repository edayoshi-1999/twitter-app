# Twitter クローン - TDD/DDD 学習プロジェクト

このプロジェクトは、TDD（テスト駆動開発）とDDD（ドメイン駆動設計）のベストプラクティスを学ぶための、Twitterクローンアプリケーションです。

## 📚 ドキュメント

- **[DOCS_INDEX.md](./DOCS_INDEX.md)** - プロジェクト全体のドキュメント索引（全ドキュメントへのリンク集）
- **[CLAUDE.md](./CLAUDE.md)** - AI アシスタント向け開発ガイドライン（プロジェクト全体の設計思想）

その他の詳細なドキュメントは [DOCS_INDEX.md](./DOCS_INDEX.md) を参照してください。

## 🛠️ 技術スタック

### フロントエンド
- React 18+
- Vite
- TypeScript
- Tailwind CSS
- Vitest + React Testing Library

### バックエンド
- Laravel 11
- PHP 8.2+
- PostgreSQL 16
- Pest (テストフレームワーク)
- Laravel Sanctum (認証)

### インフラ
- Docker Compose
- Nginx (リバースプロキシ)

## 🚀 セットアップ

### 前提条件

- Docker Desktop がインストールされていること
- Git がインストールされていること
- make コマンドが使用できること（macOS/Linuxは標準搭載、Windowsは WSL2 推奨）

### クイックスタート

```bash
# 1. リポジトリのクローン
git clone <repository-url>
cd twitter-app

# 2. プロジェクトのセットアップ（全自動）
make install
```

これだけで以下がすべて完了します：
- Dockerコンテナのビルドと起動
- Laravel の依存関係インストールと初期設定
- React の依存関係インストール
- データベースマイグレーション実行

### アプリケーションへのアクセス

- **フロントエンド**: http://localhost
- **バックエンドAPI**: http://localhost/api

### 手動セットアップ（上級者向け）

Makefileを使わない場合：

```bash
# Docker Compose でサービスを起動
docker-compose up -d

# Laravelのセットアップ
docker compose exec laravel composer install
docker compose exec laravel cp .env.example .env
docker compose exec laravel php artisan key:generate
docker compose exec laravel php artisan migrate

# Reactのセットアップ
docker compose exec react npm install
```

## 🔧 よく使うコマンド

### Make コマンド一覧

すべてのコマンドを確認：
```bash
make help
```

### Docker操作

```bash
make up          # コンテナ起動
make down        # コンテナ停止・削除
make restart     # コンテナ再起動
make ps          # コンテナ状態確認
make logs        # 全ログ表示
```

### 開発環境

```bash
make dev                # 開発環境起動（起動＋ログ表示）
make laravel            # Laravelコンテナに入る
make react              # Reactコンテナに入る
make status             # プロジェクト状態確認
```

### バックエンド開発

```bash
make migrate            # マイグレーション実行
make fresh              # DBリセット＋シード実行
make test-pest          # テスト実行（Pest）
make pint               # コードフォーマット
make tinker             # Tinker起動
make laravel-log        # Laravelログを表示
```

### フロントエンド開発

```bash
make frontend-dev       # Vite開発サーバー起動
make frontend-test      # テスト実行（Vitest）
make frontend-lint-fix  # リント＋自動修正（Biome）
make frontend-build     # プロダクションビルド
```

### コード品質（全体）

```bash
make lint               # 全リンター実行（Laravel + React）
make lint-fix           # 全リント問題を自動修正
make test-all           # 全テスト実行
```

### データベース操作

```bash
make psql               # PostgreSQL CLIに入る
make db-reset           # DBリセット
make db-dump            # DBバックアップ
```

### トラブルシューティング

```bash
make clean              # キャッシュクリア
make remake             # プロジェクト完全再構築
make down-v             # コンテナ＋ボリューム削除
```

## 📂 プロジェクト構成

```
twitter-app/
├── backend/                  # Laravel プロジェクト
├── frontend/                 # React プロジェクト
├── docker/                   # Docker 設定ファイル
│   ├── nginx/
│   │   └── default.conf     # Nginx リバースプロキシ設定
│   ├── laravel/
│   │   └── Dockerfile       # Laravel用 Dockerfile
│   └── react/
│       └── Dockerfile       # React用 Dockerfile
├── docs/                     # ドキュメント
│   ├── architecture/         # アーキテクチャ設計書
│   ├── guides/               # 開発ガイド・手順書
│   ├── tasks/                # タスクドキュメント
│   └── templates/            # PRテンプレート等
├── docker-compose.yml        # Docker Compose 設定
├── Makefile                  # 開発タスクの便利コマンド集（68個のコマンド）
├── README.md                 # プロジェクト概要（このファイル）
├── DOCS_INDEX.md             # ドキュメント索引
└── CLAUDE.md                 # AI向け開発ガイドライン
```

## 🎯 開発原則

このプロジェクトでは以下の原則を厳守します：

1. **TDD（テスト駆動開発）**: Red → Green → Refactor サイクルの徹底
2. **DDD（ドメイン駆動設計）**: ビジネスロジックをドメイン層に集約
3. **保守性重視**: 単一責任の原則、クリーンなコード
4. **ベストプラクティス**: コミュニティ標準に従った設計パターン

## 🐳 Docker サービス

| サービス | 説明 | ポート |
|---------|------|-------|
| nginx | Webサーバー/リバースプロキシ | 80 |
| laravel | Laravel API (PHP-FPM) | 9000 |
| react | React開発サーバー (Vite) | 5173 |
| db | PostgreSQL データベース | 5432 |

## 📖 次のステップ

Docker環境が起動したら、以下の順序で開発を進めます：

1. **タスク2**: ARCHITECTURE.md の作成
2. **タスク3**: Laravel プロジェクトのセットアップ
3. **タスク4**: React プロジェクトのセットアップ
4. **タスク5**: 最初のTDDサイクル（ツイート投稿機能）

詳細は以下を参照してください：
- [CLAUDE.md](./CLAUDE.md) - 開発の全体像と方針
- [DOCS_INDEX.md](./DOCS_INDEX.md) - 全ドキュメントへのリンク
- [開発再開時に読む.md](./docs/guides/開発再開時に読む.md) - 開発再開ガイド

## 🤝 貢献

このプロジェクトは学習目的のため、プルリクエストは受け付けていません。

## 📝 ライセンス

MIT License
