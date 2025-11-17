# ドキュメント索引

このプロジェクトのドキュメント体系を示します。

## 📚 ルートレベルのドキュメント

### プロジェクト概要
- **[README.md](./README.md)** - プロジェクトの基本情報と概要
- **[CLAUDE.md](./CLAUDE.md)** - AI アシスタント（Claude）向け開発ガイドライン

---

## 📂 docs/ ディレクトリ

### 🏗️ アーキテクチャ (`docs/architecture/`)
プロジェクトの設計・アーキテクチャに関するドキュメント

- **[ARCHITECTURE.md](./docs/architecture/ARCHITECTURE.md)** - システムアーキテクチャの詳細説明

### 📖 開発ガイド (`docs/guides/`)
開発に必要な手順書・ガイドライン

- **[開発ロードマップ.md](./docs/guides/開発ロードマップ.md)** - プロジェクト全体のロードマップ
- **[開発再開時に読む.md](./docs/guides/開発再開時に読む.md)** - 開発を再開する際のガイド
- **[開発者ロードマップ.md](./docs/guides/開発者ロードマップ.md)** - 開発者向けのロードマップ
- **[docker環境での動作確認.md](./docs/guides/docker環境での動作確認.md)** - Docker環境のセットアップと動作確認手順
- **[自動テスト環境セットアップ.md](./docs/guides/自動テスト環境セットアップ.md)** - 自動テスト環境の構築ガイド
- **[GIT_HOOKS_AND_CI_SETUP.md](./docs/guides/GIT_HOOKS_AND_CI_SETUP.md)** - Git Hooks と CI/CD のセットアップガイド

### ✅ タスク (`docs/tasks/`)
機能開発・実装タスクの詳細

- **[タスク1.md](./docs/tasks/タスク1.md)** - タスク1の詳細
- **[タスク2.md](./docs/tasks/タスク2.md)** - タスク2の詳細
- **[タスク3.md](./docs/tasks/タスク3.md)** - タスク3の詳細
- **[タスク4.md](./docs/tasks/タスク4.md)** - タスク4の詳細
- **[タスク5.md](./docs/tasks/タスク5.md)** - タスク5の詳細
- **[タスク6.md](./docs/tasks/タスク6.md)** - タスク6の詳細
- **[タスク6テスト.md](./docs/tasks/タスク6テスト.md)** - タスク6のテスト仕様
- **[タスク12_本番環境デプロイ.md](./docs/tasks/タスク12_本番環境デプロイ.md)** - 本番環境デプロイの手順

### 📝 テンプレート (`docs/templates/`)
プルリクエストやIssueのテンプレート

- **[PR_TEMPLATE.md](./docs/templates/PR_TEMPLATE.md)** - プルリクエストのテンプレート
- **[PR_DESCRIPTION.md](./docs/templates/PR_DESCRIPTION.md)** - プルリクエストの説明テンプレート
- **[PR_TASK6_DESCRIPTION.md](./docs/templates/PR_TASK6_DESCRIPTION.md)** - タスク6のプルリクエスト説明

---

## 🚀 クイックスタート

1. 初めての方: [README.md](./README.md) → [開発再開時に読む.md](./docs/guides/開発再開時に読む.md)
2. 環境構築: [docker環境での動作確認.md](./docs/guides/docker環境での動作確認.md)
3. 開発開始: [開発ロードマップ.md](./docs/guides/開発ロードマップ.md) → 各タスクファイル
4. AI 活用: [CLAUDE.md](./CLAUDE.md)

---

## 📌 ドキュメント管理方針

- **ルート**: プロジェクト全体の概要とAI向けガイドラインのみ
- **docs/architecture/**: アーキテクチャ設計書
- **docs/guides/**: 開発手順書・ガイドライン
- **docs/tasks/**: 機能開発タスクの詳細
- **docs/templates/**: 各種テンプレート

新しいドキュメントを追加する際は、上記の分類に従って適切なディレクトリに配置してください。
