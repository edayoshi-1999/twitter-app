# CLAUDE.md - AI アシスタント向け開発ガイドライン

## 📋 プロジェクト概要

**プロジェクト名**: Twitter クローンアプリケーション

**目的**: TDD（テスト駆動開発）、保守性、ベストプラクティスを重視した、実践的なフルスタックアプリケーションの開発を通じた学習

**重要**: このプロジェクトでは、AIアシスタント（Claude）を「シニアアーキテクト兼ペアプログラマー」として活用し、**一度にすべてをやらせるのではなく、明確な役割と制約を与え、ステップバイステップで開発を進めます**。

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

---

## 📁 プロジェクト構成

### Laravel プロジェクト構成（`backend/`）

```
backend/
├── app/
│   ├── Http/
│   │   ├── Controllers/        # コントローラー（薄く保つ）
│   │   ├── Requests/           # FormRequest（バリデーション）
│   │   └── Resources/          # API リソース（JSON変換）
│   ├── Models/                 # Eloquent モデル
│   ├── Services/               # ビジネスロジック
│   ├── Repositories/           # データアクセス層（必要に応じて）
│   └── Exceptions/             # カスタム例外
├── database/
│   ├── migrations/             # マイグレーション
│   ├── factories/              # モデルファクトリー
│   └── seeders/                # シーダー
├── tests/
│   ├── Feature/                # フィーチャーテスト（API統合テスト）
│   └── Unit/                   # ユニットテスト
├── routes/
│   └── api.php                 # API ルート定義
└── config/
    └── cors.php                # CORS 設定
```

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
**バージョン**: 1.0.0
