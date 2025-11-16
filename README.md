# Twitter クローン - TDD/DDD 学習プロジェクト

このプロジェクトは、TDD（テスト駆動開発）とDDD（ドメイン駆動設計）のベストプラクティスを学ぶための、Twitterクローンアプリケーションです。

## 📚 ドキュメント

- **[CLAUDE.md](./CLAUDE.md)** - AI アシスタント向け開発ガイドライン（プロジェクト全体の設計思想）
- **[タスク1.md](./タスク1.md)** - Docker Compose 環境構築の設計書

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

### 1. リポジトリのクローン

```bash
git clone <repository-url>
cd twitter-app
```

### 2. Docker Compose でサービスを起動

```bash
docker-compose up -d
```

### 3. アプリケーションへのアクセス

- **フロントエンド**: http://localhost:80
- **バックエンドAPI**: http://localhost:80/api

## 📂 プロジェクト構成

```
twitter-app/
├── backend/                  # Laravel プロジェクト（後続タスクで作成）
├── frontend/                 # React プロジェクト（後続タスクで作成）
├── docker/                   # Docker 設定ファイル
│   ├── nginx/
│   │   └── default.conf     # Nginx リバースプロキシ設定
│   ├── laravel/
│   │   └── Dockerfile       # Laravel用 Dockerfile
│   └── react/
│       └── Dockerfile       # React用 Dockerfile
├── docker-compose.yml        # Docker Compose 設定
├── CLAUDE.md                 # 開発ガイドライン
└── タスク1.md                # Docker環境構築の設計書
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

詳細は [CLAUDE.md](./CLAUDE.md) を参照してください。

## 🤝 貢献

このプロジェクトは学習目的のため、プルリクエストは受け付けていません。

## 📝 ライセンス

MIT License
