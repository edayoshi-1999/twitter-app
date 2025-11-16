# CLAUDE.md - AI アシスタント向け開発ガイドライン

## 📋 プロジェクト概要

**プロジェクト名**: Twitter クローンアプリケーション

**目的**: TDD（テスト駆動開発）、DDD（ドメイン駆動設計）、保守性、ベストプラクティスを重視した、実践的なフルスタックアプリケーションの開発を通じた学習

**重要**: このプロジェクトでは、AIアシスタント（Claude）を「シニアアーキテクト兼ペアプログラマー」として活用し、**一度にすべてをやらせるのではなく、明確な役割と制約を与え、ステップバイステップで開発を進めます**。

**設計哲学**: TDD で「正しく動くこと」を保証しながら、DDD で「ビジネスロジックの本質」を表現します。

---

## 🎯 AI（Claude）の役割定義

あなた（Claude）は以下の役割を担います：

### シニアソフトウェアアーキテクト
- プロジェクト構成の提案と設計レビュー
- ベストプラクティスに基づいた技術的意思決定のサポート
- アーキテクチャパターンの提案と説明

### ペアプログラマー
- TDD サイクル（Red → Green → Refactor）の厳守
- コードレビューと改善提案
- 段階的な実装のサポート

### 教育者
- 各決定の「理由」を明確に説明
- ベストプラクティスの背景を解説
- アンチパターンの指摘と代替案の提示

---

## 🛠️ 技術スタック

### フロントエンド
- **フレームワーク**: React 18+
- **ビルドツール**: Vite
- **言語**: TypeScript
- **スタイリング**: Tailwind CSS
- **状態管理**: React Context API / Zustand（必要に応じて）
- **HTTP クライアント**: Axios
- **テスト**: Vitest + React Testing Library

### バックエンド
- **フレームワーク**: Laravel 11
- **言語**: PHP 8.2+
- **認証**: Laravel Sanctum（SPA 認証）
- **テスト**: Pest（または PHPUnit）
- **API**: RESTful API

### インフラ・ツール
- **データベース**: MySQL 8.0+ / PostgreSQL
- **コンテナ**: Docker（Laravel Sail 推奨）
- **バージョン管理**: Git

### コード品質ツール

#### フロントエンド（React）
- **Biome**: 高速な統合リンター＆フォーマッター（ESLint + Prettier の代替）
  - TypeScript/JavaScript のリンティング
  - コードフォーマット
  - インポートの自動整理
- **TypeScript**: 静的型チェック

#### バックエンド（Laravel）
- **Laravel Pint**: Laravel 公式のコードスタイルフィクサー
  - PSR-12 準拠
  - Laravel スタイル
  - 自動フォーマット
- **PHPStan / Larastan**: 静的解析ツール（オプション）

#### Git Hooks
- **Husky**: Git hooks を簡単に管理
- **lint-staged**: ステージングファイルのみにリンター実行
- **Commitlint**: コミットメッセージの規約チェック（オプション）

#### CI/CD
- **GitHub Actions**: 自動テスト・デプロイ
- **自動化される処理**:
  - コード品質チェック（リンター・フォーマッター）
  - テスト実行（Unit/Feature/Integration）
  - セキュリティスキャン
  - ビルド確認

---

## 🎓 開発原則（最重要）

### 1. TDD/BDD の厳守

**「レッド・グリーン・リファクタ」サイクルを常に守る**

```
📕 Red（失敗するテストを書く）
  ↓
📗 Green（テストを通す最小限の実装）
  ↓
📘 Refactor（コードを整理・最適化）
  ↓
  繰り返し
```

#### Laravel 側のテスト戦略
- **フィーチャーテスト優先**: API エンドポイントの統合テストから始める
- **Pest の利用**: 可読性の高いテストコードを記述
- **テストファースト**: 実装コードよりも先にテストを書く

#### React 側のテスト戦略
- **コンポーネントテスト**: ユーザーの視点からのテスト
- **統合テスト**: API との連携を含むテスト
- **E2E テスト**: 必要に応じて主要フローをカバー

### 2. 保守性の重視

#### 単一責任の原則（SRP）
- 各クラス・関数は一つの責任のみを持つ
- 人間がレビューしやすい小さな単位で実装

#### クリーンなコード
- 自己文書化されたコード（わかりやすい命名）
- 適切なコメント（「なぜ」を説明、「何を」は書かない）
- DRY原則（Don't Repeat Yourself）の遵守

### 3. ベストプラクティスの遵守

#### Laravel のベストプラクティス
- **ディレクトリ構成**: Laravel の標準構成に従う
- **デザインパターン**:
  - コントローラーは薄く保つ
  - ビジネスロジックは Service クラスに分離
  - データアクセスは Repository パターン（必要に応じて）
  - FormRequest でバリデーションを分離
- **Eloquent の適切な使用**: N+1問題の回避、Eager Loading の活用

#### React のベストプラクティス
- **コンポーネント設計**:
  - 単一責任の原則
  - Presentational と Container の分離（必要に応じて）
  - カスタムフックでロジックを分離
- **TypeScript の活用**: 型安全性を最大限に活用
- **パフォーマンス**: 不要な再レンダリングの回避

### 4. DDD（ドメイン駆動設計）の採用

**DDDの本質**: ソフトウェアの中心に「ビジネスドメインの知識」を置き、技術的関心事から分離する

#### DDDの核心的な価値

1. **ユビキタス言語（Ubiquitous Language）**
   - 開発者とドメインエキスパートが同じ言葉を使う
   - コードがビジネス用語をそのまま反映
   - 例: 「ツイート」「フォロー」「タイムライン」という言葉をコード内でもそのまま使用

2. **ドメインモデルの重要性**
   - ビジネスルールはドメイン層に集約
   - データベーススキーマに引きずられない設計
   - 技術的制約ではなく、ビジネス要件から設計を始める

3. **境界づけられたコンテキスト（Bounded Context）**
   - ドメインを適切な単位で分割
   - 各コンテキスト内で一貫したモデルを持つ
   - 例: 「認証コンテキスト」「ツイートコンテキスト」「タイムラインコンテキスト」

#### TDD + DDD の相乗効果

```
TDD: 「正しく動くこと」を保証
DDD: 「何が正しいか」を明確にする

TDD だけ → 技術的には正しいが、ビジネス価値が不明瞭
DDD だけ → 設計は美しいが、動作保証がない
TDD + DDD → ビジネス価値のある、動作保証されたソフトウェア
```

#### DDDの戦術的パターン

**エンティティ（Entity）**
- 一意の識別子を持つオブジェクト
- ライフサイクル全体を通じて追跡される
- 例: `User`, `Tweet`

**値オブジェクト（Value Object）**
- 属性の値によって識別される不変オブジェクト
- 識別子を持たない
- 例: `TweetBody`, `EmailAddress`, `Username`

**集約（Aggregate）**
- 関連するオブジェクトの集まり
- 集約ルート（Aggregate Root）を通じてのみアクセス
- トランザクション境界を定義
- 例: `Tweet` 集約（Tweet本体 + Likes + Replies）

**リポジトリ（Repository）**
- ドメインオブジェクトの永続化を抽象化
- コレクションのようなインターフェース
- インフラ層の詳細を隠蔽

**ドメインサービス（Domain Service）**
- エンティティや値オブジェクトに属さないビジネスロジック
- ドメインの概念を表す操作
- 例: `FollowService`, `TimelineGenerator`

**ドメインイベント（Domain Event）**
- ドメイン内で発生した重要な出来事
- 疎結合なコンポーネント間通信
- 例: `TweetPosted`, `UserFollowed`

#### 実装の指針

**レイヤードアーキテクチャ**

```
┌─────────────────────────────────┐
│  Presentation Layer             │  ← Controllers, Resources
│  (ユーザーインターフェース)      │
├─────────────────────────────────┤
│  Application Layer              │  ← Use Cases, Application Services
│  (ユースケースの調整)           │
├─────────────────────────────────┤
│  Domain Layer                   │  ← Entities, Value Objects, Domain Services
│  (ビジネスロジックの中核)       │     Repository Interfaces
├─────────────────────────────────┤
│  Infrastructure Layer           │  ← Eloquent Models, Repository Implementations
│  (技術的詳細)                   │     External Services
└─────────────────────────────────┘
```

**依存性の方向**
- 上位層は下位層に依存できる
- **ドメイン層は何にも依存しない**（最も重要）
- インフラ層はドメイン層のインターフェースを実装

**Laravel での実装戦略**

1. **Eloquent Models ≠ Domain Entities**
   - Eloquent Model は永続化の詳細（Infrastructure）
   - Domain Entity はビジネスロジックの中心
   - 分離することで、ドメインロジックをテストしやすくする

2. **段階的な適用**
   - 最初は簡易的なDDD（Service + Repository パターン）
   - 複雑性が増すにつれて、Entity/Value Object を分離
   - プロジェクトの規模に応じて適用度を調整

---

## 📁 プロジェクト構成

### Laravel プロジェクト構成（`backend/`）- DDD 対応

```
backend/
├── app/
│   ├── Http/                           # Presentation Layer
│   │   ├── Controllers/                # コントローラー（薄く保つ）
│   │   ├── Requests/                   # FormRequest（入力バリデーション）
│   │   └── Resources/                  # API リソース（JSON 変換）
│   │
│   ├── Application/                    # Application Layer
│   │   ├── UseCases/                   # ユースケース（アプリケーションサービス）
│   │   │   ├── Tweet/
│   │   │   │   ├── CreateTweetUseCase.php
│   │   │   │   ├── DeleteTweetUseCase.php
│   │   │   │   └── GetTimelineUseCase.php
│   │   │   └── User/
│   │   │       ├── RegisterUserUseCase.php
│   │   │       └── FollowUserUseCase.php
│   │   └── DTOs/                       # データ転送オブジェクト
│   │       ├── CreateTweetData.php
│   │       └── RegisterUserData.php
│   │
│   ├── Domain/                         # Domain Layer（最重要）
│   │   ├── Tweet/                      # Tweetコンテキスト
│   │   │   ├── Entities/
│   │   │   │   └── Tweet.php           # Tweetエンティティ
│   │   │   ├── ValueObjects/
│   │   │   │   ├── TweetBody.php       # ツイート本文（Value Object）
│   │   │   │   └── TweetId.php
│   │   │   ├── Repositories/           # リポジトリインターフェース
│   │   │   │   └── TweetRepositoryInterface.php
│   │   │   ├── Services/               # ドメインサービス
│   │   │   │   └── TweetValidationService.php
│   │   │   └── Events/                 # ドメインイベント
│   │   │       ├── TweetPosted.php
│   │   │       └── TweetDeleted.php
│   │   │
│   │   ├── User/                       # Userコンテキスト
│   │   │   ├── Entities/
│   │   │   │   └── User.php
│   │   │   ├── ValueObjects/
│   │   │   │   ├── EmailAddress.php
│   │   │   │   ├── Username.php
│   │   │   │   └── Password.php
│   │   │   ├── Repositories/
│   │   │   │   └── UserRepositoryInterface.php
│   │   │   └── Services/
│   │   │       └── FollowService.php
│   │   │
│   │   └── Shared/                     # 共有ドメイン
│   │       ├── ValueObjects/
│   │       │   └── UserId.php
│   │       └── Exceptions/
│   │           ├── DomainException.php
│   │           └── ValidationException.php
│   │
│   └── Infrastructure/                 # Infrastructure Layer
│       ├── Eloquent/                   # Eloquent Models（永続化の詳細）
│       │   ├── TweetModel.php          # Eloquent Tweet Model
│       │   └── UserModel.php           # Eloquent User Model
│       ├── Repositories/               # リポジトリ実装
│       │   ├── EloquentTweetRepository.php
│       │   └── EloquentUserRepository.php
│       └── Services/                   # 外部サービス連携
│           └── ImageStorageService.php
│
├── database/
│   ├── migrations/                     # マイグレーション
│   ├── factories/                      # モデルファクトリー
│   └── seeders/                        # シーダー
│
├── tests/
│   ├── Feature/                        # フィーチャーテスト（API統合テスト）
│   │   ├── Tweet/
│   │   └── User/
│   ├── Unit/                           # ユニットテスト
│   │   ├── Domain/                     # ドメインロジックのテスト
│   │   │   ├── Tweet/
│   │   │   └── User/
│   │   └── Application/                # ユースケースのテスト
│   └── Integration/                    # インテグレーションテスト
│       └── Repositories/
│
├── routes/
│   └── api.php                         # API ルート定義
│
└── config/
    └── cors.php                        # CORS 設定
```

### DDD ディレクトリ構成のポイント

**Domain Layer（ドメイン層）**
- ビジネスロジックの中心
- フレームワークに依存しない Pure PHP
- テストが容易（DBや外部サービス不要）

**Application Layer（アプリケーション層）**
- ユースケースを調整
- ドメインオブジェクトを組み合わせて処理を実現
- トランザクション管理

**Infrastructure Layer（インフラ層）**
- Eloquent Model はここに配置
- Domain の Repository Interface を実装
- 外部サービスとの連携

### React プロジェクト構成（`frontend/`）

```
frontend/
├── src/
│   ├── components/             # React コンポーネント
│   │   ├── common/             # 共通コンポーネント
│   │   ├── tweets/             # ツイート関連コンポーネント
│   │   └── auth/               # 認証関連コンポーネント
│   ├── hooks/                  # カスタムフック
│   ├── services/               # API通信・ビジネスロジック
│   │   └── api.ts              # Axios インスタンス設定
│   ├── types/                  # TypeScript 型定義
│   ├── contexts/               # React Context
│   ├── utils/                  # ユーティリティ関数
│   ├── pages/                  # ページコンポーネント
│   └── App.tsx                 # ルートコンポーネント
├── tests/                      # テストファイル
└── vite.config.ts              # Vite 設定
```

---

## 🔄 開発ワークフロー

### ステップバイステップのアプローチ

**重要**: 一度に大量のコードを生成せず、小さなイテレーションで進めます。

### フェーズ 1: プロジェクトセットアップ

1. **プロジェクト初期化**
   - Laravel プロジェクトの作成（Laravel Sail 推奨）
   - React プロジェクトの作成（Vite）
   - 基本的な設定ファイルの構成

2. **開発環境の構築**
   - Docker 環境のセットアップ
   - データベース接続の確認
   - CORS 設定の準備

### フェーズ 2: 最初の機能実装（TDD サイクルの確立）

#### イテレーション例：ツイート投稿機能

**ステップ 1: Red（失敗するテストを書く）**

```php
// tests/Feature/TweetTest.php

it('認証されていないユーザーはツイートを投稿できない', function () {
    $response = $this->postJson('/api/tweets', [
        'body' => 'これはテストツイートです',
    ]);

    $response->assertStatus(401);
});

it('認証済みユーザーはツイートを投稿できる', function () {
    $user = User::factory()->create();

    $response = $this->actingAs($user)->postJson('/api/tweets', [
        'body' => 'これはテストツイートです',
    ]);

    $response->assertStatus(201)
        ->assertJsonStructure(['id', 'body', 'user', 'created_at']);

    $this->assertDatabaseHas('tweets', [
        'body' => 'これはテストツイートです',
        'user_id' => $user->id,
    ]);
});

it('ツイート本文が空の場合バリデーションエラーが返る', function () {
    $user = User::factory()->create();

    $response = $this->actingAs($user)->postJson('/api/tweets', [
        'body' => '',
    ]);

    $response->assertStatus(422)
        ->assertJsonValidationErrors(['body']);
});

it('ツイート本文が280文字を超える場合バリデーションエラーが返る', function () {
    $user = User::factory()->create();

    $response = $this->actingAs($user)->postJson('/api/tweets', [
        'body' => str_repeat('あ', 281),
    ]);

    $response->assertStatus(422)
        ->assertJsonValidationErrors(['body']);
});
```

**このテストを実行 → 失敗することを確認**

**ステップ 2: Green（テストを通す最小限の実装）**

1. モデルとマイグレーションの作成
2. FormRequest の作成（バリデーション）
3. コントローラーの実装
4. ルート定義

**テストを実行 → 成功することを確認**

**ステップ 3: Refactor（リファクタリング）**

- コードの重複を削除
- 可読性の向上
- パフォーマンスの最適化
- テストが引き続き通ることを確認

### フェーズ 3: 機能の拡張

各機能を同じTDDサイクルで実装：
1. ユーザー認証（Laravel Sanctum）
2. ツイート一覧表示
3. ツイート削除
4. いいね機能
5. フォロー機能
6. タイムライン表示

---

## 🤝 AI との対話方法

### 推奨プロンプトの流れ

#### プロンプト 1: プロジェクトセットアップと役割定義

```
これから、あなた（AI）をシニアソフトウェアアーキテクトとして、
ReactとLaravelを使ったTwitterクローンの開発を「TDD（テスト駆動開発）」
ベースで進めたいと思います。

以下の要件を満たすための、最初のプロジェクト構成案を提示してください。

【要件】
1. スタック:
   * フロントエンド: React (Vite, TypeScript, Tailwind CSS)
   * バックエンド: Laravel 11

2. 原則:
   * TDD/BDD: Laravel側はフィーチャーテスト（Pest）を先に書く
     「レッド・グリーン・リファクタ」のサイクルを厳守
   * 保守性: 単一責任の原則（SRP）に従ったクリーンなコードを心がける
   * ベストプラクティス: コミュニティ標準に従った設計パターンを採用

【最初のタスク】
2つのプロジェクト（Laravel APIとReactフロントエンド）をセットアップ
するための一連の bash コマンドを提示してください。

その後、ベストプラクティスに従ったディレクトリ構成や設計パターンを、
その理由と共に説明してください。
```

#### プロンプト 2: 最初の TDD サイクル（Red）

```
構成案を理解しました。それでは、TDDの「レッド（Red）」フェーズから始めます。

最初の機能として「ツイート投稿機能」を実装します。
まず、Tweet モデルとマイグレーションを作成するコマンドを教えてください。

次に、以下の仕様を満たす「ツイート投稿API (POST /api/tweets)」のための、
**"失敗する"** フィーチャーテスト（Pest）のコードを生成してください。

【テスト仕様】
1. 認証されていないユーザーはツイートを投稿できず、401エラーが返る
2. 認証済みのユーザーは、body（本文）を含むリクエストを送信すると、
   ツイートがDBに保存され、201（Created）ステータスと作成された
   ツイートのJSONが返る
3. body が空、または280文字を超える場合はバリデーションエラー（422）が返る
```

#### プロンプト 3: TDD サイクル（Green → Refactor）

```
テストが期待通り失敗しました。

それでは、先ほどのテストを「グリーン（Green）」にするために
必要な最小限のコードを実装してください。

提示してほしいコードは以下の通りです:
1. APIのエンドポイント（routes/api.php）
2. バリデーションロジック（FormRequest）
3. コントローラー（TweetController）のロジック

コード実装後、リファクタリングの余地があれば、それも指摘してください。
```

#### プロンプト 4: React 側（フロントエンド）の実装

```
TDDでAPIが完成しました。次にフロントエンド（React）の実装です。

【要件】
1. ツイートを投稿するためのフォームコンポーネント（TweetForm.tsx）を作成
2. axios を使用して POST /api/tweets エンドポイントにリクエストを送信
3. ローディング状態やエラーハンドリングも考慮
4. TypeScript の型定義を適切に行う
5. Tailwind CSS でスタイリング

【注意点】
React (localhost:5173) から Laravel (localhost:8000) へのリクエストで
発生するCORSエラーを適切に解決するための設定についても、
ベストプラクティスを教えてください。
```

#### プロンプト 5: 次のイテレーション（認証機能）

```
ツイート投稿機能の疎通が確認できました。

次のイテレーションとして、「認証」を本格的に実装します。

Laravel Sanctum を使ったSPA認証（Cookieベース）を導入したいです。
TDD（テストファースト）で以下の機能を実装する手順とコードを、
ステップバイステップで提示してください。

1. （Laravel）Sanctumのインストールと設定
2. （Laravel）「ユーザー登録（Register）」エンドポイントのTDD
   （失敗するテスト → 実装）
3. （Laravel）「ログイン」「ログアウト」エンドポイントのTDD
4. （React）認証コンテキストの作成
5. （React）ユーザー登録・ログインフォームコンポーネントの作成
```

### AI への指示の原則

1. **一度に一つのタスクのみ依頼する**
   - ❌ 悪い例: 「Twitterクローンを完成させて」
   - ✅ 良い例: 「ツイート投稿機能の失敗するテストを書いて」

2. **TDD サイクルを明示的に指示する**
   - 「まず失敗するテストを書いて」
   - 「そのテストを通す最小限の実装をして」
   - 「リファクタリングの余地を指摘して」

3. **理由を必ず聞く**
   - 「なぜこの設計パターンを選んだのか説明して」
   - 「この実装のメリット・デメリットを教えて」

4. **ベストプラクティスを要求する**
   - 「Laravel のコミュニティで推奨される方法で実装して」
   - 「セキュリティ上の問題がないか確認して」

---

## 🏗️ DDD 実装パターンと具体例

### Value Object の実装例

```php
// app/Domain/Tweet/ValueObjects/TweetBody.php
namespace App\Domain\Tweet\ValueObjects;

use App\Domain\Shared\Exceptions\ValidationException;

final class TweetBody
{
    private const MAX_LENGTH = 280;
    private const MIN_LENGTH = 1;

    private string $value;

    private function __construct(string $value)
    {
        $this->validate($value);
        $this->value = $value;
    }

    public static function create(string $value): self
    {
        return new self($value);
    }

    private function validate(string $value): void
    {
        $length = mb_strlen($value);

        if ($length < self::MIN_LENGTH) {
            throw new ValidationException('ツイート本文は空にできません');
        }

        if ($length > self::MAX_LENGTH) {
            throw new ValidationException(
                sprintf('ツイート本文は%d文字以内である必要があります', self::MAX_LENGTH)
            );
        }
    }

    public function value(): string
    {
        return $this->value;
    }

    public function equals(TweetBody $other): bool
    {
        return $this->value === $other->value;
    }

    public function __toString(): string
    {
        return $this->value;
    }
}
```

**Value Object の重要ポイント**
- ✅ 不変（Immutable）：一度作成したら変更できない
- ✅ バリデーションをコンストラクタで実行
- ✅ 値による等価性判定（`equals` メソッド）
- ✅ ビジネスルール（280文字制限）がドメイン層に表現されている

### Entity の実装例

```php
// app/Domain/Tweet/Entities/Tweet.php
namespace App\Domain\Tweet\Entities;

use App\Domain\Tweet\ValueObjects\TweetBody;
use App\Domain\Tweet\ValueObjects\TweetId;
use App\Domain\Shared\ValueObjects\UserId;
use App\Domain\Tweet\Events\TweetPosted;
use DateTimeImmutable;

class Tweet
{
    private TweetId $id;
    private TweetBody $body;
    private UserId $authorId;
    private DateTimeImmutable $postedAt;
    private array $domainEvents = [];

    private function __construct(
        TweetId $id,
        TweetBody $body,
        UserId $authorId,
        DateTimeImmutable $postedAt
    ) {
        $this->id = $id;
        $this->body = $body;
        $this->authorId = $authorId;
        $this->postedAt = $postedAt;
    }

    public static function post(
        TweetId $id,
        TweetBody $body,
        UserId $authorId
    ): self {
        $tweet = new self(
            $id,
            $body,
            $authorId,
            new DateTimeImmutable()
        );

        // ドメインイベントを記録
        $tweet->recordEvent(new TweetPosted($id, $authorId, $body));

        return $tweet;
    }

    public function id(): TweetId
    {
        return $this->id;
    }

    public function body(): TweetBody
    {
        return $this->body;
    }

    public function authorId(): UserId
    {
        return $this->authorId;
    }

    public function isPostedBy(UserId $userId): bool
    {
        return $this->authorId->equals($userId);
    }

    private function recordEvent(object $event): void
    {
        $this->domainEvents[] = $event;
    }

    public function releaseEvents(): array
    {
        $events = $this->domainEvents;
        $this->domainEvents = [];
        return $events;
    }
}
```

**Entity の重要ポイント**
- ✅ 識別子（TweetId）を持つ
- ✅ ビジネスルールを表現（`isPostedBy` など）
- ✅ ドメインイベントを記録
- ✅ Value Object を組み合わせて構成

### Repository Interface の定義

```php
// app/Domain/Tweet/Repositories/TweetRepositoryInterface.php
namespace App\Domain\Tweet\Repositories;

use App\Domain\Tweet\Entities\Tweet;
use App\Domain\Tweet\ValueObjects\TweetId;
use App\Domain\Shared\ValueObjects\UserId;

interface TweetRepositoryInterface
{
    public function save(Tweet $tweet): void;

    public function findById(TweetId $id): ?Tweet;

    public function findByAuthor(UserId $authorId, int $limit = 20): array;

    public function delete(TweetId $id): void;
}
```

**Repository Interface のポイント**
- ✅ Domain 層に配置（インターフェースのみ）
- ✅ コレクションライクなメソッド
- ✅ Domain Entity を返す

### Repository 実装（Infrastructure Layer）

```php
// app/Infrastructure/Repositories/EloquentTweetRepository.php
namespace App\Infrastructure\Repositories;

use App\Domain\Tweet\Entities\Tweet;
use App\Domain\Tweet\Repositories\TweetRepositoryInterface;
use App\Domain\Tweet\ValueObjects\{TweetId, TweetBody};
use App\Domain\Shared\ValueObjects\UserId;
use App\Infrastructure\Eloquent\TweetModel;

class EloquentTweetRepository implements TweetRepositoryInterface
{
    public function save(Tweet $tweet): void
    {
        TweetModel::updateOrCreate(
            ['id' => $tweet->id()->value()],
            [
                'body' => $tweet->body()->value(),
                'user_id' => $tweet->authorId()->value(),
                'posted_at' => $tweet->postedAt(),
            ]
        );

        // ドメインイベントをディスパッチ
        foreach ($tweet->releaseEvents() as $event) {
            event($event);
        }
    }

    public function findById(TweetId $id): ?Tweet
    {
        $model = TweetModel::find($id->value());

        if (!$model) {
            return null;
        }

        return $this->toDomainEntity($model);
    }

    public function findByAuthor(UserId $authorId, int $limit = 20): array
    {
        $models = TweetModel::where('user_id', $authorId->value())
            ->orderBy('posted_at', 'desc')
            ->limit($limit)
            ->get();

        return $models->map(fn($model) => $this->toDomainEntity($model))->all();
    }

    public function delete(TweetId $id): void
    {
        TweetModel::where('id', $id->value())->delete();
    }

    private function toDomainEntity(TweetModel $model): Tweet
    {
        // Eloquent Model から Domain Entity へ変換
        return Tweet::reconstruct(
            TweetId::fromString($model->id),
            TweetBody::create($model->body),
            UserId::fromInt($model->user_id),
            $model->posted_at
        );
    }
}
```

### UseCase（Application Service）の実装

```php
// app/Application/UseCases/Tweet/CreateTweetUseCase.php
namespace App\Application\UseCases\Tweet;

use App\Application\DTOs\CreateTweetData;
use App\Domain\Tweet\Entities\Tweet;
use App\Domain\Tweet\Repositories\TweetRepositoryInterface;
use App\Domain\Tweet\ValueObjects\{TweetId, TweetBody};
use App\Domain\Shared\ValueObjects\UserId;
use Illuminate\Support\Str;

class CreateTweetUseCase
{
    public function __construct(
        private TweetRepositoryInterface $tweetRepository
    ) {}

    public function execute(CreateTweetData $data): Tweet
    {
        // ドメインオブジェクトの生成
        $tweet = Tweet::post(
            TweetId::fromString(Str::uuid()->toString()),
            TweetBody::create($data->body),
            UserId::fromInt($data->userId)
        );

        // 永続化
        $this->tweetRepository->save($tweet);

        return $tweet;
    }
}
```

**UseCase のポイント**
- ✅ アプリケーション層のロジックを集約
- ✅ ドメインオブジェクトを組み立てる
- ✅ トランザクション境界を定義
- ✅ フレームワークの詳細から分離

### Controller での使用例（Presentation Layer）

```php
// app/Http/Controllers/TweetController.php
namespace App\Http\Controllers;

use App\Application\UseCases\Tweet\CreateTweetUseCase;
use App\Application\DTOs\CreateTweetData;
use App\Http\Requests\StoreTweetRequest;
use App\Http\Resources\TweetResource;

class TweetController extends Controller
{
    public function store(
        StoreTweetRequest $request,
        CreateTweetUseCase $useCase
    ) {
        $data = new CreateTweetData(
            body: $request->input('body'),
            userId: $request->user()->id
        );

        $tweet = $useCase->execute($data);

        return new TweetResource($tweet);
    }
}
```

**Controller のポイント**
- ✅ 非常に薄い（ビジネスロジックなし）
- ✅ リクエストの検証（FormRequest）
- ✅ UseCase の呼び出し
- ✅ レスポンスの整形（Resource）

### DDD でのテストの書き方

```php
// tests/Unit/Domain/Tweet/ValueObjects/TweetBodyTest.php
namespace Tests\Unit\Domain\Tweet\ValueObjects;

use App\Domain\Tweet\ValueObjects\TweetBody;
use App\Domain\Shared\Exceptions\ValidationException;

it('正常なツイート本文を作成できる', function () {
    $body = TweetBody::create('これはテストツイートです');

    expect($body->value())->toBe('これはテストツイートです');
});

it('空のツイート本文は作成できない', function () {
    TweetBody::create('');
})->throws(ValidationException::class, 'ツイート本文は空にできません');

it('280文字を超えるツイート本文は作成できない', function () {
    TweetBody::create(str_repeat('あ', 281));
})->throws(ValidationException::class);

it('同じ値を持つTweetBodyは等価である', function () {
    $body1 = TweetBody::create('test');
    $body2 = TweetBody::create('test');

    expect($body1->equals($body2))->toBeTrue();
});
```

```php
// tests/Unit/Domain/Tweet/Entities/TweetTest.php
namespace Tests\Unit\Domain\Tweet\Entities;

use App\Domain\Tweet\Entities\Tweet;
use App\Domain\Tweet\ValueObjects\{TweetId, TweetBody};
use App\Domain\Shared\ValueObjects\UserId;
use App\Domain\Tweet\Events\TweetPosted;

it('ツイートを投稿できる', function () {
    $tweetId = TweetId::fromString('test-id');
    $body = TweetBody::create('Hello, World!');
    $authorId = UserId::fromInt(1);

    $tweet = Tweet::post($tweetId, $body, $authorId);

    expect($tweet->id())->toBe($tweetId);
    expect($tweet->body())->toBe($body);
    expect($tweet->authorId())->toBe($authorId);
});

it('ツイート投稿時にドメインイベントが記録される', function () {
    $tweet = Tweet::post(
        TweetId::fromString('test-id'),
        TweetBody::create('Hello'),
        UserId::fromInt(1)
    );

    $events = $tweet->releaseEvents();

    expect($events)->toHaveCount(1);
    expect($events[0])->toBeInstanceOf(TweetPosted::class);
});

it('投稿者を判定できる', function () {
    $authorId = UserId::fromInt(1);
    $tweet = Tweet::post(
        TweetId::fromString('test-id'),
        TweetBody::create('Hello'),
        $authorId
    );

    expect($tweet->isPostedBy($authorId))->toBeTrue();
    expect($tweet->isPostedBy(UserId::fromInt(2)))->toBeFalse();
});
```

**DDD でのテストのポイント**
- ✅ Domain 層はDB不要でテスト可能
- ✅ ビジネスルールに焦点を当てる
- ✅ 高速に実行できる
- ✅ フレームワークに依存しない

### TDD + DDD の開発フロー

```
1. ドメインモデリング
   ↓ （ユビキタス言語で概念を整理）
2. Value Object のテスト（Red）
   ↓
3. Value Object の実装（Green）
   ↓
4. Entity のテスト（Red）
   ↓
5. Entity の実装（Green）
   ↓
6. UseCase のテスト（Red）
   ↓
7. UseCase の実装（Green）
   ↓
8. Repository の実装（Infrastructure）
   ↓
9. Controller の実装（Presentation）
   ↓
10. API フィーチャーテスト
```

**ポイント**
- ドメイン層から外側へ向かって実装
- 各層で TDD サイクルを回す
- ドメインロジックは DB なしでテスト

---

## 📝 コーディング規約

### Laravel

#### 命名規則
- **モデル**: 単数形、パスカルケース（例: `Tweet`, `User`）
- **コントローラー**: モデル名 + `Controller`（例: `TweetController`）
- **メソッド**: キャメルケース（例: `storeTweet`, `getUserTimeline`）
- **ルート名**: ドットネーション、スネークケース（例: `tweets.store`, `user.timeline`）

#### コントローラーの責務
```php
// ❌ 悪い例: コントローラーにビジネスロジックが多い
public function store(Request $request)
{
    $validated = $request->validate([...]);

    // ビジネスロジックがコントローラーに...
    $tweet = Tweet::create([...]);
    $tweet->mentions()->attach([...]);
    $tweet->hashtags()->sync([...]);
    // 通知処理...
    // 画像処理...

    return response()->json($tweet, 201);
}

// ✅ 良い例: サービスクラスに分離
public function store(StoreTweetRequest $request, TweetService $tweetService)
{
    $tweet = $tweetService->createTweet(
        $request->user(),
        $request->validated()
    );

    return new TweetResource($tweet);
}
```

#### FormRequest の活用
```php
// app/Http/Requests/StoreTweetRequest.php
class StoreTweetRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user() !== null;
    }

    public function rules(): array
    {
        return [
            'body' => ['required', 'string', 'max:280'],
            'images' => ['nullable', 'array', 'max:4'],
            'images.*' => ['image', 'max:5120'], // 5MB
        ];
    }
}
```

### React / TypeScript

#### 命名規則
- **コンポーネント**: パスカルケース（例: `TweetForm`, `UserProfile`）
- **フック**: `use` プレフィックス（例: `useTweets`, `useAuth`）
- **型定義**: パスカルケース、`Type` サフィックス（例: `TweetType`, `UserType`）
- **ファイル名**: コンポーネントと同じ名前（例: `TweetForm.tsx`）

#### コンポーネント設計
```tsx
// ❌ 悪い例: 責務が多すぎる
function TweetPage() {
  const [tweets, setTweets] = useState([]);
  const [loading, setLoading] = useState(false);
  // データ取得、状態管理、UI、すべてが混在...
}

// ✅ 良い例: カスタムフックで分離
function TweetPage() {
  const { tweets, loading, error, createTweet } = useTweets();

  return (
    <div>
      <TweetForm onSubmit={createTweet} />
      <TweetList tweets={tweets} loading={loading} error={error} />
    </div>
  );
}

// hooks/useTweets.ts
function useTweets() {
  // データ取得と状態管理のロジック
}
```

#### 型定義の明示
```tsx
// ❌ 悪い例: any 型の使用
function TweetCard({ tweet }: { tweet: any }) {
  // ...
}

// ✅ 良い例: 適切な型定義
interface Tweet {
  id: number;
  body: string;
  user: User;
  created_at: string;
  likes_count: number;
}

function TweetCard({ tweet }: { tweet: Tweet }) {
  // TypeScriptの恩恵を最大限に受けられる
}
```

---

## 🧪 テスト戦略

### Laravel テスト

#### テストの粒度
1. **フィーチャーテスト（優先）**: API エンドポイントの統合テスト
2. **ユニットテスト**: 複雑なビジネスロジック、ヘルパー関数

#### Pest の記述スタイル
```php
// ✅ 読みやすいテスト
it('allows authenticated users to create tweets', function () {
    $user = User::factory()->create();

    $response = $this->actingAs($user)->postJson('/api/tweets', [
        'body' => 'Hello, World!',
    ]);

    $response->assertStatus(201);
    expect($response->json('body'))->toBe('Hello, World!');
});

// データセットを使った複数ケースのテスト
it('validates tweet body length', function (string $body, int $expectedStatus) {
    $user = User::factory()->create();

    $response = $this->actingAs($user)->postJson('/api/tweets', [
        'body' => $body,
    ]);

    $response->assertStatus($expectedStatus);
})->with([
    ['valid tweet', 201],
    ['', 422],
    [str_repeat('a', 281), 422],
]);
```

### React テスト

#### React Testing Library の活用
```tsx
// ✅ ユーザーの視点からのテスト
import { render, screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';

describe('TweetForm', () => {
  it('allows users to submit a tweet', async () => {
    const onSubmit = vi.fn();
    render(<TweetForm onSubmit={onSubmit} />);

    const input = screen.getByPlaceholderText('What's happening?');
    const submitButton = screen.getByRole('button', { name: 'Tweet' });

    await userEvent.type(input, 'Hello, World!');
    await userEvent.click(submitButton);

    await waitFor(() => {
      expect(onSubmit).toHaveBeenCalledWith({ body: 'Hello, World!' });
    });
  });
});
```

---

## ⚠️ 避けるべきアンチパターン

### AI に依頼する際の注意点

#### ❌ 避けるべき依頼方法

1. **大量のコードを一度に生成させる**
   ```
   ❌ 「Twitterクローンのすべての機能を実装して」
   → 保守性の低い、テストのない巨大なコードが返ってくる
   ```

2. **テストを後回しにする**
   ```
   ❌ 「まず全機能を実装して、後でテストを書く」
   → TDD の原則に反する、テストが形骸化する
   ```

3. **理由を聞かずに実装を進める**
   ```
   ❌ AIが提示したコードをそのまま採用
   → 学習機会の損失、設計の意図が不明
   ```

#### ✅ 推奨される依頼方法

1. **小さな単位で段階的に実装**
   ```
   ✅ 「まず Tweet モデルの失敗するテストを書いて」
   ✅ 「そのテストを通す最小限の実装をして」
   ✅ 「次に、ツイート一覧取得のテストを書いて」
   ```

2. **常にテストファースト**
   ```
   ✅ 「Red → Green → Refactor のサイクルで進めます」
   ✅ 「まず失敗するテストから書いてください」
   ```

3. **設計の意図を確認**
   ```
   ✅ 「なぜ Repository パターンを使うのか説明して」
   ✅ 「この実装のトレードオフは何ですか？」
   ```

### コーディングのアンチパターン

#### Laravel

❌ **Fat Controller（太ったコントローラー）**
```php
// すべてのロジックをコントローラーに詰め込む
```

❌ **N+1 クエリ問題**
```php
// Eager Loading を使わない
foreach ($users as $user) {
    echo $user->tweets->count(); // 各ユーザーごとにクエリ発行
}
```

❌ **マスアサインメント脆弱性**
```php
// $fillable の設定なしに create を使う
```

#### React

❌ **巨大なコンポーネント**
```tsx
// 500行以上の単一コンポーネント
```

❌ **prop drilling（過度なプロップの受け渡し）**
```tsx
// 5階層以上のコンポーネントツリーでpropsを受け渡す
```

❌ **any 型の濫用**
```tsx
// TypeScript を使いながら any ばかり使う
```

---

## 🔐 セキュリティチェックリスト

### Laravel

- [ ] マスアサインメント対策（`$fillable` または `$guarded` の設定）
- [ ] CSRF 保護（API では Sanctum を使用）
- [ ] SQL インジェクション対策（Eloquent ORM の使用）
- [ ] XSS 対策（Blade のエスケープ、API では責務外）
- [ ] 認証・認可の適切な実装
- [ ] レート制限の設定
- [ ] 環境変数の適切な管理（`.env` をコミットしない）

### React

- [ ] XSS 対策（React のデフォルトエスケープに依存）
- [ ] 機密情報をクライアントサイドに保存しない
- [ ] HTTPS の使用（本番環境）
- [ ] 依存パッケージの脆弱性チェック（`npm audit`）

---

## 🛠️ コード品質ツールのセットアップ

### フロントエンド: Biome のセットアップ

#### 1. Biome のインストール

```bash
cd frontend
npm install --save-dev --save-exact @biomejs/biome
```

#### 2. Biome の初期化

```bash
npx @biomejs/biome init
```

#### 3. `biome.json` の設定

```json
{
  "$schema": "https://biomejs.dev/schemas/1.4.1/schema.json",
  "organizeImports": {
    "enabled": true
  },
  "linter": {
    "enabled": true,
    "rules": {
      "recommended": true,
      "complexity": {
        "noExtraBooleanCast": "error",
        "noMultipleSpacesInRegularExpressionLiterals": "error",
        "noUselessCatch": "error",
        "noWith": "error"
      },
      "correctness": {
        "noConstAssign": "error",
        "noConstantCondition": "error",
        "noEmptyCharacterClassInRegex": "error",
        "noEmptyPattern": "error",
        "noGlobalObjectCalls": "error",
        "noInvalidConstructorSuper": "error",
        "noInvalidNewBuiltin": "error",
        "noNonoctalDecimalEscape": "error",
        "noPrecisionLoss": "error",
        "noSelfAssign": "error",
        "noSetterReturn": "error",
        "noSwitchDeclarations": "error",
        "noUndeclaredVariables": "error",
        "noUnreachable": "error",
        "noUnreachableSuper": "error",
        "noUnsafeFinally": "error",
        "noUnsafeOptionalChaining": "error",
        "noUnusedLabels": "error",
        "noUnusedVariables": "error",
        "useIsNan": "error",
        "useValidForDirection": "error",
        "useYield": "error"
      },
      "style": {
        "noNamespace": "error",
        "useAsConstAssertion": "error"
      },
      "suspicious": {
        "noAsyncPromiseExecutor": "error",
        "noCatchAssign": "error",
        "noClassAssign": "error",
        "noCompareNegZero": "error",
        "noControlCharactersInRegex": "error",
        "noDebugger": "error",
        "noDuplicateCase": "error",
        "noDuplicateClassMembers": "error",
        "noDuplicateObjectKeys": "error",
        "noDuplicateParameters": "error",
        "noEmptyBlockStatements": "error",
        "noExplicitAny": "warn",
        "noExtraNonNullAssertion": "error",
        "noFallthroughSwitchClause": "error",
        "noFunctionAssign": "error",
        "noGlobalAssign": "error",
        "noImportAssign": "error",
        "noMisleadingCharacterClass": "error",
        "noMisleadingInstantiator": "error",
        "noPrototypeBuiltins": "error",
        "noRedeclare": "error",
        "noShadowRestrictedNames": "error",
        "noUnsafeDeclarationMerging": "error",
        "noUnsafeNegation": "error",
        "useGetterReturn": "error",
        "useValidTypeof": "error"
      }
    }
  },
  "formatter": {
    "enabled": true,
    "formatWithErrors": false,
    "indentStyle": "space",
    "indentWidth": 2,
    "lineEnding": "lf",
    "lineWidth": 100,
    "attributePosition": "auto"
  },
  "javascript": {
    "formatter": {
      "jsxQuoteStyle": "double",
      "quoteProperties": "asNeeded",
      "trailingComma": "es5",
      "semicolons": "always",
      "arrowParentheses": "always",
      "bracketSpacing": true,
      "bracketSameLine": false,
      "quoteStyle": "single",
      "attributePosition": "auto"
    }
  },
  "overrides": [
    {
      "include": ["*.ts", "*.tsx", "*.mts", "*.cts"],
      "linter": {
        "rules": {
          "correctness": {
            "noConstAssign": "off",
            "noGlobalObjectCalls": "off",
            "noInvalidConstructorSuper": "off",
            "noInvalidNewBuiltin": "off",
            "noNewSymbol": "off",
            "noSetterReturn": "off",
            "noUndeclaredVariables": "off",
            "noUnreachable": "off",
            "noUnreachableSuper": "off"
          },
          "style": {
            "noArguments": "error",
            "noVar": "error",
            "useConst": "error"
          },
          "suspicious": {
            "noDuplicateClassMembers": "off",
            "noDuplicateObjectKeys": "off",
            "noDuplicateParameters": "off",
            "noFunctionAssign": "off",
            "noImportAssign": "off",
            "noRedeclare": "off",
            "noUnsafeNegation": "off",
            "useGetterReturn": "off"
          }
        }
      }
    }
  ]
}
```

#### 4. `package.json` にスクリプト追加

```json
{
  "scripts": {
    "lint": "biome lint ./src",
    "lint:fix": "biome lint --apply ./src",
    "format": "biome format ./src",
    "format:fix": "biome format --write ./src",
    "check": "biome check ./src",
    "check:fix": "biome check --apply ./src"
  }
}
```

#### 5. VS Code の設定（`.vscode/settings.json`）

```json
{
  "editor.defaultFormatter": "biomejs.biome",
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "quickfix.biome": "explicit",
    "source.organizeImports.biome": "explicit"
  },
  "[javascript]": {
    "editor.defaultFormatter": "biomejs.biome"
  },
  "[typescript]": {
    "editor.defaultFormatter": "biomejs.biome"
  },
  "[javascriptreact]": {
    "editor.defaultFormatter": "biomejs.biome"
  },
  "[typescriptreact]": {
    "editor.defaultFormatter": "biomejs.biome"
  }
}
```

### バックエンド: Laravel Pint のセットアップ

#### 1. Laravel Pint のインストール（Laravel 11 には標準で含まれる）

```bash
cd backend
composer require laravel/pint --dev
```

#### 2. `pint.json` の設定

```json
{
  "preset": "laravel",
  "rules": {
    "simplified_null_return": true,
    "braces": false,
    "new_with_braces": {
      "anonymous_class": false,
      "named_class": false
    },
    "method_argument_space": {
      "on_multiline": "ensure_fully_multiline"
    }
  }
}
```

#### 3. `composer.json` にスクリプト追加

```json
{
  "scripts": {
    "lint": "pint --test -v",
    "lint:fix": "pint -v",
    "test": "pest",
    "test:coverage": "pest --coverage"
  }
}
```

### Git Hooks のセットアップ（Husky + lint-staged）

#### 1. Husky と lint-staged のインストール（フロントエンド側）

```bash
cd frontend
npm install --save-dev husky lint-staged
npx husky init
```

#### 2. `.husky/pre-commit` の設定

```bash
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

# フロントエンドのlint-staged実行
cd frontend && npx lint-staged

# バックエンドのLaravel Pint実行
cd ../backend && composer lint:fix
git add -A
```

#### 3. `package.json` に lint-staged の設定

```json
{
  "lint-staged": {
    "*.{js,jsx,ts,tsx}": [
      "biome check --apply --no-errors-on-unmatched"
    ]
  }
}
```

#### 4. コミットメッセージの規約（オプション）

Commitlint を使用する場合：

```bash
npm install --save-dev @commitlint/{config-conventional,cli}
echo "module.exports = {extends: ['@commitlint/config-conventional']}" > commitlint.config.js
npx husky add .husky/commit-msg 'npx --no -- commitlint --edit ${1}'
```

**コミットメッセージの形式**:
```
<type>(<scope>): <subject>

<body>

<footer>
```

**type の例**:
- `feat`: 新機能
- `fix`: バグ修正
- `docs`: ドキュメントのみの変更
- `style`: コードの意味に影響しない変更（空白、フォーマット等）
- `refactor`: リファクタリング
- `test`: テストの追加・修正
- `chore`: ビルドプロセスやツールの変更

---

## 🚀 CI/CD のセットアップ（GitHub Actions）

### ディレクトリ構成

```
.github/
└── workflows/
    ├── frontend-ci.yml      # フロントエンドのCI
    ├── backend-ci.yml       # バックエンドのCI
    └── deploy.yml           # デプロイ（オプション）
```

### フロントエンド CI: `.github/workflows/frontend-ci.yml`

```yaml
name: Frontend CI

on:
  push:
    branches: [main, develop]
    paths:
      - 'frontend/**'
      - '.github/workflows/frontend-ci.yml'
  pull_request:
    branches: [main, develop]
    paths:
      - 'frontend/**'
      - '.github/workflows/frontend-ci.yml'

defaults:
  run:
    working-directory: frontend

jobs:
  lint-and-test:
    runs-on: ubuntu-latest

    strategy:
      matrix:
        node-version: [20.x]

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Node.js ${{ matrix.node-version }}
        uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
          cache: 'npm'
          cache-dependency-path: frontend/package-lock.json

      - name: Install dependencies
        run: npm ci

      - name: Run Biome lint
        run: npm run lint

      - name: Run Biome format check
        run: npm run format

      - name: Type check
        run: npx tsc --noEmit

      - name: Run tests
        run: npm test -- --run

      - name: Build
        run: npm run build

      - name: Upload build artifacts
        if: success()
        uses: actions/upload-artifact@v4
        with:
          name: frontend-build
          path: frontend/dist
          retention-days: 7

  security-scan:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Run npm audit
        run: npm audit --audit-level=moderate
        continue-on-error: true

      - name: Run Snyk security scan
        uses: snyk/actions/node@master
        continue-on-error: true
        env:
          SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
        with:
          args: --severity-threshold=high
```

### バックエンド CI: `.github/workflows/backend-ci.yml`

```yaml
name: Backend CI

on:
  push:
    branches: [main, develop]
    paths:
      - 'backend/**'
      - '.github/workflows/backend-ci.yml'
  pull_request:
    branches: [main, develop]
    paths:
      - 'backend/**'
      - '.github/workflows/backend-ci.yml'

defaults:
  run:
    working-directory: backend

jobs:
  lint-and-test:
    runs-on: ubuntu-latest

    services:
      mysql:
        image: mysql:8.0
        env:
          MYSQL_ROOT_PASSWORD: password
          MYSQL_DATABASE: testing
        ports:
          - 3306:3306
        options: >-
          --health-cmd="mysqladmin ping"
          --health-interval=10s
          --health-timeout=5s
          --health-retries=3

    strategy:
      matrix:
        php-version: [8.2, 8.3]

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup PHP ${{ matrix.php-version }}
        uses: shivammathur/setup-php@v2
        with:
          php-version: ${{ matrix.php-version }}
          extensions: mbstring, dom, fileinfo, mysql, redis
          coverage: xdebug

      - name: Get Composer cache directory
        id: composer-cache
        run: echo "dir=$(composer config cache-files-dir)" >> $GITHUB_OUTPUT

      - name: Cache Composer dependencies
        uses: actions/cache@v4
        with:
          path: ${{ steps.composer-cache.outputs.dir }}
          key: ${{ runner.os }}-composer-${{ hashFiles('**/composer.lock') }}
          restore-keys: ${{ runner.os }}-composer-

      - name: Install dependencies
        run: composer install --prefer-dist --no-progress --no-interaction

      - name: Copy .env
        run: cp .env.example .env

      - name: Generate application key
        run: php artisan key:generate

      - name: Run Laravel Pint (linter)
        run: composer lint

      - name: Run PHPStan (static analysis)
        run: ./vendor/bin/phpstan analyse --memory-limit=2G
        continue-on-error: true

      - name: Run database migrations
        run: php artisan migrate --force
        env:
          DB_CONNECTION: mysql
          DB_HOST: 127.0.0.1
          DB_PORT: 3306
          DB_DATABASE: testing
          DB_USERNAME: root
          DB_PASSWORD: password

      - name: Run tests (Pest)
        run: composer test
        env:
          DB_CONNECTION: mysql
          DB_HOST: 127.0.0.1
          DB_PORT: 3306
          DB_DATABASE: testing
          DB_USERNAME: root
          DB_PASSWORD: password

      - name: Run tests with coverage
        run: composer test:coverage
        env:
          DB_CONNECTION: mysql
          DB_HOST: 127.0.0.1
          DB_PORT: 3306
          DB_DATABASE: testing
          DB_USERNAME: root
          DB_PASSWORD: password

      - name: Upload coverage reports to Codecov
        uses: codecov/codecov-action@v4
        with:
          file: ./backend/coverage.xml
          flags: backend
          name: backend-coverage
        env:
          CODECOV_TOKEN: ${{ secrets.CODECOV_TOKEN }}

  security-scan:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup PHP
        uses: shivammathur/setup-php@v2
        with:
          php-version: 8.2

      - name: Install dependencies
        run: composer install --prefer-dist --no-progress

      - name: Run security audit
        run: composer audit
```

### CI/CD のベストプラクティス

#### 1. ブランチ戦略

```
main (本番)
  ↑
develop (開発)
  ↑
feature/* (機能開発)
  ↑
```

- `feature/*` → `develop`: プルリクエスト時に CI 実行
- `develop` → `main`: マージ前に全テスト実行
- `main`: デプロイ前の最終確認

#### 2. テストの分類と実行タイミング

| テスト種別 | 実行タイミング | 目的 |
|-----------|--------------|------|
| リンター・フォーマッター | コミット時（pre-commit） | コードスタイルの統一 |
| ユニットテスト | プッシュ時（CI） | 個別ロジックの確認 |
| 統合テスト | プルリクエスト時（CI） | コンポーネント間の連携確認 |
| E2Eテスト | マージ前（CI） | ユーザーフロー全体の確認 |
| セキュリティスキャン | 定期実行（nightly） | 脆弱性の早期発見 |

#### 3. パフォーマンス最適化

- **キャッシュ活用**: `node_modules`, `vendor`, Composer cache
- **並列実行**: 複数の PHP バージョンでテスト
- **条件付き実行**: 変更のあったディレクトリのみ CI 実行

#### 4. 通知設定

**Slack 通知の例**:

```yaml
- name: Notify Slack on failure
  if: failure()
  uses: 8398a7/action-slack@v3
  with:
    status: ${{ job.status }}
    text: 'CI failed on ${{ github.ref }}'
    webhook_url: ${{ secrets.SLACK_WEBHOOK }}
```

### ローカルでの CI/CD シミュレーション

#### Act を使用してローカルで GitHub Actions をテスト

```bash
# Act のインストール（macOS）
brew install act

# ワークフローの実行
act -j lint-and-test

# 特定のイベントをシミュレート
act pull_request
```

---

## 📊 コード品質メトリクス

### 監視すべき指標

1. **テストカバレッジ**: 80% 以上を目標
2. **コード重複率**: 5% 以下
3. **循環的複雑度**: 関数あたり 10 以下
4. **技術的負債**: SonarQube スコア A 評価
5. **ビルド時間**: 5分以内

### ツールの統合

- **Codecov**: テストカバレッジの可視化
- **SonarQube/SonarCloud**: コード品質の総合分析
- **Dependabot**: 依存パッケージの自動更新

---

## 📚 参考リソース

### Laravel
- [Laravel 公式ドキュメント](https://laravel.com/docs)
- [Pest 公式ドキュメント](https://pestphp.com)
- [Laravel Best Practices](https://github.com/alexeymezenin/laravel-best-practices)

### React
- [React 公式ドキュメント](https://react.dev)
- [TypeScript 公式ドキュメント](https://www.typescriptlang.org)
- [React Testing Library](https://testing-library.com/react)

### TDD
- [Test Driven Development: By Example - Kent Beck](https://www.amazon.com/dp/0321146530)
- [Growing Object-Oriented Software, Guided by Tests](https://www.amazon.com/dp/0321503627)

### DDD（ドメイン駆動設計）
- **必読書籍**
  - [エリック・エヴァンスのドメイン駆動設計](https://www.amazon.co.jp/dp/4798121967) - DDD のバイブル
  - [実践ドメイン駆動設計](https://www.amazon.co.jp/dp/479813161X) - Vaughn Vernon 著、実践的な解説
  - [ドメイン駆動設計 モデリング/実装ガイド](https://booth.pm/ja/items/1835632) - 日本語で読みやすい入門書

- **オンラインリソース**
  - [Domain-Driven Design Reference](https://www.domainlanguage.com/ddd/reference/) - Eric Evans による公式リファレンス
  - [PHP/Laravel で DDD を実践する](https://qiita.com/tags/ddd) - Qiita の DDD タグ

- **重要な概念**
  - ユビキタス言語（Ubiquitous Language）
  - 境界づけられたコンテキスト（Bounded Context）
  - エンティティ vs 値オブジェクト
  - 集約（Aggregate）とその境界
  - リポジトリパターン
  - ドメインイベント

---

## 🎯 開発の進め方（まとめ）

### フェーズごとの進行

1. **準備フェーズ**
   - プロジェクトのセットアップ
   - 開発環境の構築
   - 最初のエンドポイントまでの疎通確認

2. **基本機能フェーズ**（TDD で各機能を実装）
   - 認証機能（Sanctum）
   - ツイートCRUD
   - ユーザープロフィール

3. **応用機能フェーズ**
   - いいね機能
   - フォロー機能
   - タイムライン

4. **最適化フェーズ**
   - パフォーマンスチューニング
   - E2Eテストの追加
   - デプロイ準備

### 各イテレーションの流れ

```
1. 要件定義（明確な仕様）
   ↓
2. テスト作成（Red）
   ↓
3. 実装（Green）
   ↓
4. リファクタリング（Refactor）
   ↓
5. レビュー（AI と対話）
   ↓
6. 次のイテレーションへ
```

---

## 💡 最後に

このドキュメントは、AI（Claude）を効果的に活用しながら、**実践的なスキルを身につける**ためのガイドラインです。

**重要な心構え**:
- AI が生成したコードを盲目的に受け入れない
- 常に「なぜ？」を問い、理解を深める
- TDD のリズムを体で覚える
- 小さな成功を積み重ねる

**成功の鍵**:
- 一度に一つのことに集中する
- テストファーストを徹底する
- AI との対話を通じて学び続ける

このプロジェクトを通じて、保守性の高い、プロフェッショナルなコードを書く力を身につけましょう！

---

**最終更新日**: 2025-11-16
**バージョン**: 3.0.0

**変更履歴**:
- v3.0.0 (2025-11-16): コード品質ツールとCI/CDの内容を追加
  - Biome（フロントエンド）のセットアップ手順と設定
  - Laravel Pint（バックエンド）のセットアップ手順
  - Git Hooks（Husky + lint-staged）の導入方法
  - GitHub Actions を使った CI/CD の完全なワークフロー例
  - フロントエンド CI（リンター、テスト、ビルド、セキュリティスキャン）
  - バックエンド CI（リンター、静的解析、テスト、カバレッジ）
  - ブランチ戦略とテスト実行タイミングの表
  - コード品質メトリクスの監視指標
  - Commitlint によるコミットメッセージ規約
- v2.0.0 (2025-11-16): DDD（ドメイン駆動設計）の内容を追加
  - DDDの本質と核心的な価値を解説
  - TDD + DDD の相乗効果を説明
  - DDD対応のディレクトリ構成を提示
  - Value Object, Entity, Repository などの具体的な実装例を追加
  - レイヤードアーキテクチャの詳細を記載
  - DDD参考リソースを追加
- v1.0.0 (2025-11-16): 初版リリース
