# Git Hooks と CI/CD のセットアップガイド

このドキュメントでは、プロジェクトに導入されたGit HooksとGitHub Actions CI/CDの設定について説明します。

## 📋 概要

このプロジェクトでは、コード品質を保つために以下の自動化を導入しています：

1. **Git Hooks（ローカル）** - コミット時にリンター・フォーマッターを自動実行
2. **GitHub Actions（CI/CD）** - プッシュ・PR作成時にテスト・ビルドを自動実行

---

## 🔧 Git Hooks（コミット時の自動チェック）

### 仕組み

コミット実行時（`git commit`）に、自動的に以下が実行されます：

1. **フロントエンド**: Biome による lint・format・type check
2. **バックエンド**: Laravel Pint によるコードスタイル修正

### 使用しているツール

- **Husky**: Git Hooks を簡単に管理するツール
- **lint-staged**: ステージングされたファイルのみに対してコマンドを実行

### セットアップ（初回のみ）

プロジェクトをクローンした後、以下のコマンドを実行してください：

```bash
# プロジェクトルートで実行
npm install
```

これにより、以下が自動的にセットアップされます：
- Huskyのインストール
- lint-stagedのインストール
- pre-commitフックの有効化

### 動作確認

1. フロントエンドのファイルを編集（例: `frontend/src/App.tsx`）
2. 変更をステージング:
   ```bash
   git add frontend/src/App.tsx
   ```
3. コミット:
   ```bash
   git commit -m "test: verify pre-commit hook"
   ```

コミット時に、自動的に以下が実行されます：
- フロントエンド: `biome check --write`（変更されたファイルのみ）
- バックエンド: `pint`（変更されたPHPファイルのみ）

### トラブルシューティング

#### pre-commitフックが実行されない場合

```bash
# フックの実行権限を確認
ls -la .git/hooks/pre-commit

# 権限がない場合は付与
chmod +x .git/hooks/pre-commit
```

#### フックをスキップしたい場合（非推奨）

```bash
git commit -m "message" --no-verify
```

⚠️ **注意**: `--no-verify`は緊急時のみ使用してください。コード品質が低下する可能性があります。

---

## 🚀 GitHub Actions（CI/CD）

### 仕組み

以下のタイミングで、GitHub Actions が自動実行されます：

1. **プッシュ時**: `main`, `develop`, `claude/**`ブランチへのプッシュ
2. **プルリクエスト作成時**: `main`, `develop`へのPR作成

### ワークフロー

#### フロントエンドCI（`.github/workflows/frontend-ci.yml`）

**トリガー**: `frontend/`ディレクトリ内のファイルが変更された場合

**実行内容**:
1. Node.js 20.x のセットアップ
2. 依存関係のインストール（`npm ci`）
3. Biome lint（`npm run lint`）
4. Biome format check（`npm run format`）
5. Biome 総合チェック（`npm run check`）
6. TypeScript型チェック（`tsc --noEmit`）
7. テスト実行（`npm test -- --run`）
8. ビルド（`npm run build`）
9. ビルド成果物のアップロード（7日間保持）

#### バックエンドCI（`.github/workflows/backend-ci.yml`）

**トリガー**: `backend/`ディレクトリ内のファイルが変更された場合

**実行内容**:
1. PHP 8.2, 8.3 のマトリックスビルド
2. MySQL 8.0 サービスコンテナの起動
3. Composer依存関係のインストール
4. 環境ファイルのコピーとキー生成
5. Laravel Pint（`composer lint`）
6. データベースマイグレーション
7. Pest テスト実行（`composer test`）
8. カバレッジレポート生成（`composer test:coverage`）

### CI実行結果の確認

1. GitHubリポジトリページを開く
2. 上部の「Actions」タブをクリック
3. 最新のワークフロー実行を確認

### ローカルでCIをシミュレーション

```bash
# フロントエンド
cd frontend
npm ci
npm run lint
npm run format
npm run check
npx tsc --noEmit
npm test -- --run
npm run build

# バックエンド
cd backend
composer install
composer lint
php artisan migrate
composer test
composer test:coverage
```

---

## 📊 ワークフロー図

```
コード変更
    ↓
git add <files>
    ↓
git commit -m "message"
    ↓
【ローカル: Git Hooks】
├─ Biome check（フロントエンド）
└─ Laravel Pint（バックエンド）
    ↓
（通過した場合）コミット成功
    ↓
git push
    ↓
【リモート: GitHub Actions】
├─ Frontend CI
│  ├─ Lint
│  ├─ Format check
│  ├─ Type check
│  ├─ Tests
│  └─ Build
└─ Backend CI
   ├─ Lint
   ├─ Tests
   └─ Coverage
    ↓
（全て成功）✅ CIパス
```

---

## 🛠️ カスタマイズ

### Git Hooksの設定変更

`package.json`の`lint-staged`セクションを編集：

```json
{
  "lint-staged": {
    "frontend/**/*.{js,jsx,ts,tsx}": [
      "npm run check:fix --prefix frontend"
    ],
    "backend/**/*.php": [
      "composer lint:fix --working-dir=backend"
    ]
  }
}
```

### GitHub Actionsの設定変更

#### トリガーブランチの追加

`.github/workflows/frontend-ci.yml`または`backend-ci.yml`の`on.push.branches`を編集：

```yaml
on:
  push:
    branches: [main, develop, claude/**, feature/**]
```

#### Node.jsバージョンの変更

```yaml
strategy:
  matrix:
    node-version: [18.x, 20.x, 22.x]
```

#### PHPバージョンの変更

```yaml
strategy:
  matrix:
    php-version: [8.2, 8.3, 8.4]
```

---

## 📝 ベストプラクティス

### コミット前

1. 変更をステージング前にローカルでテスト実行
   ```bash
   npm test  # フロントエンド
   composer test  # バックエンド
   ```

2. 大きな変更は小さなコミットに分割

3. 意味のあるコミットメッセージを記述
   ```bash
   git commit -m "feat: ユーザー認証機能を追加"
   git commit -m "fix: タイムライン表示のバグを修正"
   git commit -m "refactor: Tweet モデルをリファクタリング"
   ```

### プルリクエスト作成前

1. ローカルでCIシミュレーションを実行

2. ブランチを最新の`develop`と同期
   ```bash
   git fetch origin develop
   git rebase origin/develop
   ```

3. CIが通ることを確認してからレビュー依頼

---

## 🔍 トラブルシューティング

### CIが失敗する場合

#### 1. ローカルでは成功するがCIで失敗

**原因**: 環境の違い（Node.js/PHPバージョン、依存関係など）

**対処**:
```bash
# Node.jsバージョンを確認
node -v

# PHPバージョンを確認
php -v

# 依存関係を再インストール
npm ci  # フロントエンド
composer install  # バックエンド
```

#### 2. タイムアウトエラー

**原因**: テストやビルドに時間がかかりすぎる

**対処**: ワークフローファイルに`timeout-minutes`を追加
```yaml
jobs:
  lint-and-test:
    runs-on: ubuntu-latest
    timeout-minutes: 30  # デフォルトは60分
```

#### 3. 依存関係のインストールエラー

**原因**: `package-lock.json`や`composer.lock`の不整合

**対処**:
```bash
# フロントエンド
rm -rf node_modules package-lock.json
npm install

# バックエンド
rm -rf vendor composer.lock
composer install
```

---

## 📚 参考リンク

- [Husky 公式ドキュメント](https://typicode.github.io/husky/)
- [lint-staged 公式ドキュメント](https://github.com/okonet/lint-staged)
- [GitHub Actions 公式ドキュメント](https://docs.github.com/ja/actions)
- [Biome 公式ドキュメント](https://biomejs.dev/)
- [Laravel Pint 公式ドキュメント](https://laravel.com/docs/pint)

---

**最終更新日**: 2025-11-16
