# feat: Git Hooks と GitHub Actions CI/CD の自動化設定

## 概要

コミット・プッシュ・PR作成時に自動的にテストやフォーマッターが実行されるように、Git Hooks と GitHub Actions CI/CD を設定しました。

## 変更内容

### 1. Git Hooks（ローカル自動化）

**目的**: コミット前にコード品質を自動チェック

**導入ツール**:
- **Husky**: Git Hooks 管理ツール
- **lint-staged**: ステージングされたファイルのみに対してコマンド実行

**動作**:
- コミット時（`git commit`）に `pre-commit` フックが自動実行
- フロントエンド: Biome による lint + format + check
- バックエンド: Laravel Pint によるコードスタイル修正
- 変更されたファイルのみが対象（高速）

**設定ファイル**:
- `/package.json` - Husky + lint-staged の設定
- `/.git/hooks/pre-commit` - Git フック
- `/.husky/pre-commit` - Husky フック定義

### 2. GitHub Actions CI/CD

#### フロントエンドCI (`.github/workflows/frontend-ci.yml`)

**トリガー**:
- プッシュ: `main`, `develop`, `claude/**` ブランチ
- プルリクエスト: `main`, `develop` へのPR作成時
- パス: `frontend/**` 内のファイル変更時

**実行内容**:
1. Node.js 20.x 環境セットアップ
2. 依存関係インストール（`npm ci`）
3. Biome lint チェック
4. Biome format チェック
5. Biome 総合チェック
6. TypeScript 型チェック（`tsc --noEmit`）
7. テスト実行（Vitest）
8. ビルド（`npm run build`）
9. ビルド成果物の保存（7日間）

#### バックエンドCI (`.github/workflows/backend-ci.yml`)

**トリガー**:
- プッシュ: `main`, `develop`, `claude/**` ブランチ
- プルリクエスト: `main`, `develop` へのPR作成時
- パス: `backend/**` 内のファイル変更時

**実行内容**:
1. PHP 8.2, 8.3 マトリックスビルド
2. MySQL 8.0 サービスコンテナ起動
3. Composer 依存関係インストール
4. 環境ファイル設定（`.env`）
5. Laravel Pint コードスタイルチェック
6. データベースマイグレーション
7. Pest テスト実行
8. カバレッジレポート生成

### 3. ドキュメント

**`docs/GIT_HOOKS_AND_CI_SETUP.md`**:
- セットアップ手順
- 使い方
- トラブルシューティング
- カスタマイズ方法
- ベストプラクティス

### 4. その他の変更

- **ルート `package.json`** の追加（Husky 管理用）
- **ルート `.gitignore`** の追加
- **フロントエンド `package.json`** に Husky, lint-staged を追加

## 動作確認

### ローカル（Git Hooks）

```bash
# フロントエンドファイルを編集
echo "// test" >> frontend/src/App.tsx

# コミット時に自動的にBiomeが実行される
git add frontend/src/App.tsx
git commit -m "test: verify pre-commit hook"
# → Biome が自動実行されます
```

### リモート（GitHub Actions）

このPRをマージ後、以下のタイミングでCIが自動実行されます：

1. **プッシュ時**: `main`, `develop`, `claude/**` ブランチへプッシュ
2. **PR作成時**: `main`, `develop` へのPR作成
3. **変更検知**: `frontend/**` または `backend/**` 内のファイル変更

## テスト計画

- [ ] ローカルでコミット時にpre-commitフックが実行されることを確認
- [ ] GitHub ActionsでフロントエンドCIが実行されることを確認
- [ ] GitHub ActionsでバックエンドCIが実行されることを確認
- [ ] 各CIジョブが成功することを確認

## 参照

- [CLAUDE.md - コード品質ツール](../CLAUDE.md#🛠️-コード品質ツールのセットアップ)
- [CLAUDE.md - CI/CD](../CLAUDE.md#🚀-cicdのセットアップgithub-actions)
- [docs/GIT_HOOKS_AND_CI_SETUP.md](../docs/GIT_HOOKS_AND_CI_SETUP.md) - 詳細ドキュメント

## 注意事項

### 初回セットアップが必要

このブランチをチェックアウトした後、以下のコマンドを実行してください：

```bash
# プロジェクトルートで実行
npm install
```

これにより、Husky と lint-staged がインストールされ、Git Hooks が有効化されます。

### CI実行時間

- フロントエンドCI: 約3-5分
- バックエンドCI: 約5-10分（PHP 8.2, 8.3 並列実行）

### コスト

GitHub Actions の無料枠内で十分実行可能です（月2,000分）。

---

**関連ISSUE**: #8（想定）
**タスク**: タスク8 - Git Hooks と CI/CD の自動化
