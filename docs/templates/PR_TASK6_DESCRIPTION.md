# タスク6: TDDによるツイート投稿機能の実装と開発環境整備

## 📋 概要

TDD（テスト駆動開発）の「Red → Green → Refactor」サイクルを実践し、ツイート投稿機能を実装しました。
さらに、開発効率を向上させる自動テスト環境と包括的なドキュメントを整備しました。

**主な成果**:
- ✅ ツイート投稿API（`POST /api/tweets`）の実装
- ✅ TDDサイクルの完全な実践
- ✅ 自動テスト環境の構築（ファイル監視モード）
- ✅ 包括的なドキュメント整備

---

## 🎯 実装内容

### 1️⃣ ツイート投稿機能（TDDサイクル）

#### Step 1: 🔴 Red（失敗するテストを書く）

**作成ファイル**: `tests/Feature/Tweet/TweetTest.php`

4つのテストケースを実装：

| # | テスト内容 | 期待結果 |
|---|-----------|---------|
| 1 | 認証されていないユーザーがツイート投稿 | 401 Unauthorized |
| 2 | 認証済みユーザーがツイート投稿 | 201 Created |
| 3 | ツイート本文が空 | 422 Validation Error |
| 4 | ツイート本文が280文字超 | 422 Validation Error |

```php
it('認証済みユーザーはツイートを投稿できる', function () {
    $user = User::factory()->create();

    $response = $this->actingAs($user)->postJson('/api/tweets', [
        'body' => 'これはテストツイートです',
    ]);

    $response->assertStatus(201)
        ->assertJsonStructure(['id', 'body', 'user', 'created_at', 'posted_at']);

    $this->assertDatabaseHas('tweets', [
        'body' => 'これはテストツイートです',
        'user_id' => $user->id,
    ]);
});
```

---

#### Step 2: 🟢 Green（テストを通す最小限の実装）

**1. FormRequest の作成**: `app/Http/Requests/StoreTweetRequest.php`

```php
class StoreTweetRequest extends FormRequest
{
    private const MAX_TWEET_LENGTH = 280;

    public function authorize(): bool
    {
        return $this->user() !== null;
    }

    public function rules(): array
    {
        return [
            'body' => ['required', 'string', 'max:'.self::MAX_TWEET_LENGTH],
        ];
    }
}
```

**特徴**:
- バリデーションロジックをControllerから分離
- マジックナンバー（280）を定数化
- カスタムエラーメッセージ

---

**2. Controller の実装**: `app/Http/Controllers/TweetController.php`

```php
public function store(StoreTweetRequest $request): JsonResponse
{
    $tweet = Tweet::create([
        'body' => $request->input('body'),
        'user_id' => $request->user()->id,
        'posted_at' => now(),
    ]);

    $tweet->load('user');

    return response()->json([
        'id' => $tweet->id,
        'body' => $tweet->body,
        'user' => [
            'id' => $tweet->user->id,
            'name' => $tweet->user->name,
        ],
        'created_at' => $tweet->created_at->toIso8601String(),
        'posted_at' => $tweet->posted_at->toIso8601String(),
    ], 201);
}
```

**特徴**:
- 薄いController（ビジネスロジックなし）
- Eager Loading でN+1問題を回避
- 適切なHTTPステータスコード（201 Created）

---

**3. ルート定義**: `routes/api.php`

```php
Route::post('/tweets', [TweetController::class, 'store'])
    ->middleware('auth:sanctum');
```

---

**4. モデル拡張**: `app/Models/User.php`

```php
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    public function tweets(): HasMany
    {
        return $this->hasMany(Tweet::class);
    }
}
```

---

#### Step 3: 🔵 Refactor（リファクタリング）

**実施内容**:
- ✅ マジックナンバー（280）を定数化（`MAX_TWEET_LENGTH`）
- ✅ Laravel Pint でコードスタイル自動修正
- ✅ posted_at フィールドの追加（自己レビューで発見）

---

### 2️⃣ Laravel Sanctum の導入

**インストール**:
```bash
composer require laravel/sanctum
php artisan install:api
```

**設定内容**:
- ✅ API routing の有効化
- ✅ Sanctum middleware の設定
- ✅ User モデルに `HasApiTokens` トレイト追加

---

### 3️⃣ 自動テスト環境の構築

#### ファイル監視による自動テスト実行

**Composer スクリプト追加** (`backend/composer.json`):

```json
{
  "scripts": {
    "test": "pest",
    "test:watch": "pest --watch",
    "test:tweets": "pest tests/Feature/Tweet/",
    "dev:test": "pest --watch"
  }
}
```

**使用方法**:
```bash
# 自動テスト起動（ファイル保存で自動実行）
docker-compose exec laravel composer dev:test
```

---

#### tmux統合スクリプト

**作成ファイル**: `scripts/dev.sh`

**機能**:
- Docker Compose サービス自動起動
- Laravel 自動テスト起動（ファイル監視モード）
- ログ監視ウィンドウ
- シェルウィンドウ
- すべてを tmux で統合管理

**使用方法**:
```bash
./scripts/dev.sh
```

**tmux 操作**:
- `Ctrl+b` → `0`: Laravel テスト画面
- `Ctrl+b` → `1`: ログ画面
- `Ctrl+b` → `2`: シェル画面
- `Ctrl+b` → `d`: デタッチ

---

#### VS Code Tasks 統合

**作成ファイル**: `.vscode/tasks.json`

**追加タスク**:
- 🧪 Laravel: Watch Tests（デフォルトテストタスク）
- ✅ Laravel: Run Tests
- 📊 Laravel: Test Coverage
- 🐦 Laravel: Test Tweets Only
- 🎨 Laravel: Lint Code
- 🔧 Laravel: Fix Code Style
- 🚀 Dev: Start All Services (tmux)
- 🐳 Docker: Start/Stop Services
- 🔄 Laravel: Migrate Database

**使用方法**:
VS Code で `Ctrl+Shift+P` → `Tasks: Run Task`

---

### 4️⃣ ドキュメント整備

#### 1. タスク6.md（新人エンジニア向け実装ガイド）

**内容**:
- TDDの基本概念
- Red → Green → Refactor サイクルの詳細
- 各ステップの実装コード例
- よくある質問とトラブルシューティング
- 学習成果のまとめ

**位置**: `docs/タスク6.md`

---

#### 2. タスク6テスト.md（テスト実行手順）

**内容**:
- Docker Compose環境でのテスト実行方法
- 各テストケースの詳細説明
- トラブルシューティング
- テスト完了チェックリスト

**位置**: `docs/タスク6テスト.md`

---

#### 3. 自動テスト環境セットアップ.md

**内容**:
- ファイル監視による自動テスト環境の構築
- tmux統合の詳細
- VS Code統合の設定
- カスタマイズ方法

**位置**: `docs/自動テスト環境セットアップ.md`

---

#### 4. 開発者ロードマップ.md（プロジェクト進捗管理）

**内容**:
- プロジェクト全体の進捗状況
- 完了したタスクの詳細
- 次のタスクの計画
- 進捗率の可視化（6/26タスク完了、23%）

**位置**: `docs/開発者ロードマップ.md`

---

#### 5. scripts/README.md（開発スクリプトガイド）

**内容**:
- 開発スクリプトの使用方法
- TDDワークフローの実践例
- デバッグ方法

**位置**: `scripts/README.md`

---

## 🐛 自己レビューと修正

### 発見した問題（3件）

#### 1. posted_at フィールドが設定されていない（重大）

**問題**:
- マイグレーションで `posted_at` が NOT NULL として定義
- Controller で設定し忘れ
- データベースエラーの可能性

**修正**:
```php
$tweet = Tweet::create([
    'body' => $request->input('body'),
    'user_id' => $request->user()->id,
    'posted_at' => now(),  // ← 追加
]);
```

---

#### 2. テストケースが不完全

**修正**:
```php
->assertJsonStructure(['id', 'body', 'user', 'created_at', 'posted_at']);
```

---

#### 3. .env.example が古い設定

**修正**:
```env
DB_CONNECTION=pgsql
DB_HOST=db
DB_PORT=5432
DB_DATABASE=twitter_clone
DB_USERNAME=laravel_user
DB_PASSWORD=secret
```

---

## 📊 変更ファイル一覧

### バックエンド（Laravel）

| ファイル | 変更内容 |
|---------|---------|
| `app/Http/Controllers/TweetController.php` | ツイート投稿API実装 |
| `app/Http/Requests/StoreTweetRequest.php` | バリデーションロジック |
| `app/Models/User.php` | HasApiTokens、tweets()リレーション追加 |
| `routes/api.php` | POST /api/tweets エンドポイント追加 |
| `tests/Feature/Tweet/TweetTest.php` | フィーチャーテスト（4ケース） |
| `composer.json` | テストスクリプト追加 |
| `.env.example` | PostgreSQL設定に更新 |
| `bootstrap/app.php` | API routing有効化 |
| `phpunit.xml` | PostgreSQL設定に更新 |

### ドキュメント

| ファイル | 内容 |
|---------|------|
| `docs/タスク6.md` | 実装ガイド（新人エンジニア向け） |
| `docs/タスク6テスト.md` | テスト実行手順 |
| `docs/自動テスト環境セットアップ.md` | 自動テスト環境ガイド |
| `docs/開発者ロードマップ.md` | プロジェクト進捗管理 |
| `scripts/README.md` | 開発スクリプトガイド |

### 開発環境

| ファイル | 内容 |
|---------|------|
| `scripts/dev.sh` | tmux統合開発環境起動スクリプト |
| `.vscode/tasks.json` | VS Code Tasks設定 |

---

## 🧪 テスト

### テスト実行方法

**Docker環境で実行**:
```bash
# すべてのテストを実行
docker-compose exec laravel composer test

# 自動テスト（ファイル監視モード）
docker-compose exec laravel composer dev:test

# ツイート機能のみ
docker-compose exec laravel composer test:tweets

# カバレッジ付き
docker-compose exec laravel composer test:coverage
```

### テスト結果

```
✅ PASS  Tests\Feature\Tweet\TweetTest
  ✓ 認証されていないユーザーはツイートを投稿できない
  ✓ 認証済みユーザーはツイートを投稿できる
  ✓ ツイート本文が空の場合バリデーションエラーが返る
  ✓ ツイート本文が280文字を超える場合バリデーションエラーが返る

Tests:  4 passed (12 assertions)
```

---

## 🚀 使い方

### 開発環境の起動

**方法1: tmux統合スクリプト（推奨）**

```bash
./scripts/dev.sh
```

自動的に以下が起動されます：
- Docker Compose サービス
- Laravel 自動テスト
- ログ監視
- シェル

**方法2: 手動起動**

```bash
# ターミナル1: Docker起動
docker-compose up -d

# ターミナル2: 自動テスト
docker-compose exec laravel composer dev:test
```

---

### TDD開発フロー

```
1. 自動テスト起動
   $ ./scripts/dev.sh

2. テストを書く（Red）
   - tests/Feature/Tweet/TweetTest.php を編集
   - ファイルを保存 → 自動的にテストが実行される
   - ❌ テストが失敗（これが正しい）

3. 実装を書く（Green）
   - app/Http/Controllers/TweetController.php を編集
   - ファイルを保存 → 自動的にテストが実行される
   - ✅ テストが成功

4. リファクタリング（Refactor）
   - コードを整理・最適化
   - ファイルを保存 → 自動的にテストが実行される
   - ✅ テストが引き続き成功

5. 繰り返し
```

---

## 📈 開発効率の向上

### Before（手動テスト）

```bash
# コードを編集
# ターミナルに切り替え
$ docker-compose exec laravel composer test
# 結果を確認
# コードに戻る
# 繰り返し... 😓
```

### After（自動テスト）

```bash
# 一度だけ起動
$ ./scripts/dev.sh

# あとはコードを書くだけ！
# 保存すると自動的にテストが実行される ✨
# 即座にフィードバック 🎯
```

**効果**:
- ⚡ TDDサイクルが超高速化
- 🎯 即座にフィードバック
- 🧠 集中力が途切れない
- ✅ テストを書く習慣が身につく

---

## 🎓 学んだこと

### 技術的スキル

- ✅ TDDの「Red → Green → Refactor」サイクル
- ✅ Laravel Pestによるテスト駆動開発
- ✅ FormRequestによるバリデーション分離
- ✅ Controllerの責務（薄く保つ）
- ✅ Laravel Sanctumの基本設定
- ✅ ファイル監視による自動テスト環境

### 設計原則

- ✅ 単一責任の原則（SRP）
- ✅ テストファーストの重要性
- ✅ 小さく作ることの価値
- ✅ リファクタリングの安全性

### ベストプラクティス

- ✅ マイグレーションとの整合性確認
- ✅ テストの完全性（すべてのフィールドを検証）
- ✅ 自己レビューの重要性

---

## ✅ チェックリスト

### 実装

- [x] フィーチャーテスト（4ケース）がすべて成功
- [x] バリデーションが正しく動作
- [x] 認証チェックが機能
- [x] データベースに正しく保存される
- [x] JSONレスポンスが適切
- [x] posted_atフィールドが設定される

### コード品質

- [x] Laravel Pint でコードスタイルチェック
- [x] 単一責任の原則を遵守
- [x] マジックナンバーを定数化
- [x] コメントが適切

### ドキュメント

- [x] 実装ガイド作成（タスク6.md）
- [x] テスト手順作成（タスク6テスト.md）
- [x] 自動テスト環境ガイド作成
- [x] 開発者ロードマップ更新

### 開発環境

- [x] 自動テスト環境構築
- [x] tmux統合スクリプト作成
- [x] VS Code Tasks設定
- [x] Composerスクリプト追加

### Git

- [x] すべての変更をコミット
- [x] ブランチにプッシュ
- [x] コミットメッセージが明確

---

## 📝 次のステップ

### タスク7: Laravel Sanctum認証の本格導入

**実装予定**:
- ユーザー登録API（`POST /api/register`）
- ログインAPI（`POST /api/login`）
- ログアウトAPI（`POST /api/logout`）
- 認証済みユーザー情報取得API（`GET /api/user`）

**推定工数**: 4時間

---

## 🔗 関連リソース

### ドキュメント

- [タスク6.md](./docs/タスク6.md) - 実装ガイド
- [タスク6テスト.md](./docs/タスク6テスト.md) - テスト手順
- [自動テスト環境セットアップ.md](./docs/自動テスト環境セットアップ.md) - 自動テスト環境
- [開発者ロードマップ.md](./docs/開発者ロードマップ.md) - プロジェクト進捗
- [scripts/README.md](./scripts/README.md) - 開発スクリプト

### 技術スタック

- [Laravel 11](https://laravel.com/docs/11.x)
- [Laravel Sanctum](https://laravel.com/docs/11.x/sanctum)
- [Pest](https://pestphp.com)
- [Laravel Pint](https://laravel.com/docs/11.x/pint)
- [Docker Compose](https://docs.docker.com/compose/)

---

## 👥 レビュワーへ

### レビューポイント

1. **TDDサイクルの実践**
   - テストが実装前に書かれているか
   - テストが適切に失敗→成功しているか

2. **コード品質**
   - Controllerが薄く保たれているか
   - バリデーションが適切に分離されているか
   - posted_atフィールドが設定されているか

3. **ドキュメント**
   - 新人エンジニアが理解できる内容か
   - 手順が明確か

4. **開発環境**
   - 自動テスト環境が正しく動作するか
   - tmuxスクリプトが問題なく起動するか

### 確認コマンド

```bash
# テスト実行
docker-compose exec laravel composer test

# コードスタイルチェック
docker-compose exec laravel ./vendor/bin/pint --test

# 自動テスト環境起動
./scripts/dev.sh
```

---

**PR作成日**: 2025-11-16
**実装者**: Claude（AIアシスタント）+ edayoshi-1999
**レビュー**: 自己レビュー完了、コードスタイルチェック完了
