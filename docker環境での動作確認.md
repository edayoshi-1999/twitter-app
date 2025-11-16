# タスク5: Docker Compose 統合と動作確認

> 💡 **このタスクの目的**
> フロントエンド（React）とバックエンド（Laravel）をDocker Compose環境で統合し、すべてのサービスが正常に連携して動作することを確認します。

**実施日**: 2025-11-16
**前提条件**: タスク3（Laravel）とタスク4（React）が完了していること

---

## 📋 目次

1. [実施内容の概要](#1-実施内容の概要)
2. [事前準備](#2-事前準備)
3. [各ステップの詳細説明](#3-各ステップの詳細説明)
4. [動作確認](#4-動作確認)
5. [トラブルシューティング](#5-トラブルシューティング)
6. [次のステップ](#6-次のステップ)

---

## 1. 実施内容の概要

このタスクでは、以下の7つのステップを実施します：

| # | タスク | 説明 |
|---|--------|------|
| 1 | 環境の確認 | Docker、Docker Composeのインストール確認 |
| 2 | Docker Composeでビルド | すべてのコンテナをビルド |
| 3 | コンテナの起動 | すべてのサービスを起動 |
| 4 | Laravel初期セットアップ | Composer install、マイグレーション実行 |
| 5 | フロントエンド動作確認 | ブラウザでReactアプリにアクセス |
| 6 | バックエンドAPI確認 | Laravelエンドポイントの疎通確認 |
| 7 | 統合テスト | フロントエンドとバックエンドの連携確認 |

---

## 2. 事前準備

### 2.1. 必要なソフトウェア

以下がインストールされていることを確認してください：

| ソフトウェア | バージョン | 確認コマンド |
|------------|----------|------------|
| **Docker** | 20.10以上 | `docker --version` |
| **Docker Compose** | 2.0以上 | `docker compose version` |

### 2.2. インストール方法（参考）

#### macOS
```bash
# Homebrewを使用
brew install --cask docker
```

#### Windows
- [Docker Desktop for Windows](https://docs.docker.com/desktop/install/windows-install/) をダウンロード＆インストール

#### Linux (Ubuntu)
```bash
# Dockerのインストール
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Docker Composeのインストール
sudo apt-get update
sudo apt-get install docker-compose-plugin

# 現在のユーザーをdockerグループに追加（再ログイン後に有効）
sudo usermod -aG docker $USER
```

### 2.3. プロジェクト構成の確認

プロジェクトルートに以下のファイルが存在することを確認：

```bash
twitter-app/
├── docker-compose.yml           # ✅ 必須
├── backend/                     # ✅ Laravel プロジェクト
│   ├── composer.json
│   ├── .env
│   └── ...
├── frontend/                    # ✅ React プロジェクト
│   ├── package.json
│   ├── vite.config.ts
│   └── ...
└── docker/                      # ✅ Docker設定
    ├── nginx/default.conf
    ├── laravel/Dockerfile
    └── react/Dockerfile
```

---

## 3. 各ステップの詳細説明

### ステップ1: 環境の確認

#### 何をするか？

Docker と Docker Compose が正しくインストールされているかを確認します。

#### 実行するコマンド

```bash
# プロジェクトルートに移動
cd /path/to/twitter-app

# Dockerのバージョン確認
docker --version

# Docker Composeのバージョン確認
docker compose version

# Dockerが起動しているか確認
docker ps
```

#### 期待される出力

```
Docker version 24.0.0, build ...
Docker Compose version v2.20.0

CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
（まだコンテナがない場合は空）
```

#### トラブルシューティング

**問題**: `docker: command not found`
- **解決策**: Dockerをインストールしてください（2.2参照）

**問題**: `permission denied`
- **解決策**:
  ```bash
  # ユーザーをdockerグループに追加
  sudo usermod -aG docker $USER
  # 再ログイン
  ```

---

### ステップ2: Docker Composeでビルド

#### 何をするか？

すべてのサービス（Nginx、Laravel、React、PostgreSQL）のDockerイメージをビルドします。

#### なぜ必要？

- 各サービスの実行環境を準備
- 依存関係をインストール
- カスタム設定を反映

#### 実行するコマンド

```bash
# すべてのサービスをビルド
docker compose build

# または、ビルドと起動を同時に実行
docker compose up --build -d
```

**オプションの説明**:
- `--build`: イメージを再ビルド
- `-d`: デタッチドモード（バックグラウンドで実行）

#### 期待される出力

```
[+] Building 45.2s (32/32) FINISHED
 => [laravel internal] load build definition from Dockerfile
 => [react internal] load build definition from Dockerfile
...
[+] Running 5/5
 ✔ Network twitter-network    Created
 ✔ Container twitter-db        Started
 ✔ Container twitter-laravel   Started
 ✔ Container twitter-react     Started
 ✔ Container twitter-nginx     Started
```

#### ビルド時間の目安

- **初回**: 5〜10分（依存パッケージのダウンロード）
- **2回目以降**: 1〜2分（キャッシュ利用）

---

### ステップ3: コンテナの起動

#### 何をするか？

すべてのコンテナを起動し、サービスが正常に稼働しているか確認します。

#### 実行するコマンド

```bash
# コンテナの起動（すでに起動している場合はスキップ）
docker compose up -d

# コンテナの状態確認
docker compose ps

# ログを確認（全サービス）
docker compose logs -f
```

**ログ表示の終了**: `Ctrl + C`

#### 期待される出力（docker compose ps）

```
NAME                IMAGE                   COMMAND                  SERVICE   STATUS         PORTS
twitter-db          postgres:16-alpine      "docker-entrypoint.s…"   db        Up 30 seconds  0.0.0.0:5432->5432/tcp
twitter-laravel     twitter-app-laravel     "docker-php-entrypoi…"   laravel   Up 29 seconds  9000/tcp
twitter-nginx       nginx:alpine            "/docker-entrypoint.…"   nginx     Up 28 seconds  0.0.0.0:80->80/tcp
twitter-react       twitter-app-react       "docker-entrypoint.s…"   react     Up 29 seconds  5173/tcp
```

**重要なポイント**:
- すべてのコンテナの `STATUS` が `Up` であること
- `twitter-nginx` が `0.0.0.0:80->80/tcp` でポート80を公開していること

#### 各サービスのログを個別に確認

```bash
# Reactのログ
docker compose logs -f react

# Laravelのログ
docker compose logs -f laravel

# データベースのログ
docker compose logs -f db

# Nginxのログ
docker compose logs -f nginx
```

#### 正常なログの例

**React**:
```
twitter-react |
twitter-react |   VITE v7.2.2  ready in 1234 ms
twitter-react |
twitter-react |   ➜  Local:   http://localhost:5173/
twitter-react |   ➜  Network: http://0.0.0.0:5173/
```

**Laravel**:
```
twitter-laravel | [16-Nov-2025 09:00:00] NOTICE: fpm is running, pid 1
twitter-laravel | [16-Nov-2025 09:00:00] NOTICE: ready to handle connections
```

**PostgreSQL**:
```
twitter-db | database system is ready to accept connections
```

---

### ステップ4: Laravel初期セットアップ

#### 何をするか？

Laravelコンテナ内で、Composerパッケージのインストール、データベースマイグレーションなどの初期設定を行います。

#### ステップ4-1: Composerパッケージのインストール

```bash
# Laravelコンテナに入る
docker compose exec laravel sh

# Composerパッケージをインストール
composer install

# インストール完了後、コンテナから出る
exit
```

#### ステップ4-2: .envファイルの確認

```bash
# Laravelの.envファイルを確認
docker compose exec laravel cat .env | grep DB_
```

**期待される出力**:
```
DB_CONNECTION=pgsql
DB_HOST=db
DB_PORT=5432
DB_DATABASE=twitter_clone
DB_USERNAME=laravel_user
DB_PASSWORD=secret
```

**重要**: `DB_HOST=db` になっていること（Docker Composeのサービス名）

#### ステップ4-3: アプリケーションキーの生成

```bash
# アプリケーションキーを生成（まだ生成していない場合）
docker compose exec laravel php artisan key:generate
```

**期待される出力**:
```
Application key set successfully.
```

#### ステップ4-4: データベース接続テスト

```bash
# データベース接続を確認
docker compose exec laravel php artisan migrate:status
```

**初回の場合**:
```
Migration table not found.
```
→ これは正常です。次のステップでマイグレーションを実行します。

#### ステップ4-5: データベースマイグレーションの実行

```bash
# マイグレーションを実行
docker compose exec laravel php artisan migrate
```

**期待される出力**:
```
  Running migrations.

  0001_01_01_000000_create_users_table ............................ 15ms DONE
  0001_01_01_000001_create_cache_table ............................ 12ms DONE
  0001_01_01_000002_create_jobs_table ............................. 25ms DONE
  2025_11_16_083648_create_tweets_table ........................... 18ms DONE
```

**確認**:
```bash
# マイグレーション状態を再確認
docker compose exec laravel php artisan migrate:status
```

**期待される出力**:
```
  Migration name .............................. Batch / Status
  0001_01_01_000000_create_users_table ........ [1] Ran
  0001_01_01_000001_create_cache_table ........ [1] Ran
  0001_01_01_000002_create_jobs_table ......... [1] Ran
  2025_11_16_083648_create_tweets_table ....... [1] Ran
```

#### ステップ4-6: ストレージディレクトリの権限設定

```bash
# 権限を設定（Laravelがログやキャッシュを書き込めるように）
docker compose exec laravel chmod -R 775 storage bootstrap/cache
docker compose exec laravel chown -R www-data:www-data storage bootstrap/cache
```

**確認**:
```bash
docker compose exec laravel ls -la storage/
```

#### ステップ4-7: テストデータの投入（オプション）

```bash
# ユーザーとツイートのテストデータを作成
docker compose exec laravel php artisan tinker
```

**Tinker内で実行**:
```php
// ユーザーを3人作成
$users = \App\Models\User::factory()->count(3)->create();

// 各ユーザーにツイートを5件ずつ作成
$users->each(function ($user) {
    \App\Models\Tweet::factory()->count(5)->create([
        'user_id' => $user->id
    ]);
});

// 作成されたデータを確認
\App\Models\User::count();
\App\Models\Tweet::count();

// Tinkerを終了
exit
```

**期待される出力**:
```
=> 3  // ユーザー数
=> 15 // ツイート数
```

---

### ステップ5: フロントエンド動作確認

#### 何をするか？

ブラウザでReactアプリケーションにアクセスし、正しく表示されることを確認します。

#### アクセスするURL

```
http://localhost/
```

#### 期待される表示

✅ **成功時**:
- "Twitter Clone" のタイトルが表示される
- "React + Vite + TypeScript + Tailwind CSS" のサブタイトルが表示される
- 青い "Get Started" ボタンが表示される
- Tailwind CSSのスタイルが適用されている（中央配置、グレー背景）

#### ブラウザの開発者ツールで確認

1. `F12` キーを押して開発者ツールを開く
2. **Console** タブを確認
   - ✅ エラーがないこと
   - ✅ 警告が最小限であること

3. **Network** タブを確認
   - ページをリロード
   - ✅ すべてのリソース（HTML、CSS、JS）が200で返ってくること

#### HMR（Hot Module Replacement）のテスト

1. VSCodeなどで `frontend/src/App.tsx` を開く
2. タイトルを変更してみる：
   ```tsx
   <h1 className="text-4xl font-bold text-gray-900 mb-4">
     Twitter Clone - HMR Test
   </h1>
   ```
3. ファイルを保存
4. ブラウザが**自動的にリロードされず**、**変更が即座に反映される**ことを確認

✅ **HMRが正常に動作している証拠**: ページ全体がリロードされず、変更部分のみが更新される

---

### ステップ6: バックエンドAPI確認

#### 何をするか？

LaravelのAPIエンドポイントが正しく動作しているか確認します。

#### ステップ6-1: ヘルスチェックエンドポイントの作成（オプション）

LaravelにヘルスチェックAPIを追加：

**`backend/routes/api.php`を編集**:
```php
<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

// ヘルスチェック
Route::get('/health', function () {
    return response()->json([
        'status' => 'ok',
        'service' => 'Laravel API',
        'timestamp' => now()->toISOString(),
    ]);
});

// 認証が必要なエンドポイント（後で実装）
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/user', function (Request $request) {
        return $request->user();
    });
});
```

#### ステップ6-2: APIエンドポイントにアクセス

**方法1: ブラウザでアクセス**
```
http://localhost/api/health
```

**期待されるレスポンス**:
```json
{
  "status": "ok",
  "service": "Laravel API",
  "timestamp": "2025-11-16T09:15:30.000000Z"
}
```

**方法2: curlコマンド**
```bash
curl http://localhost/api/health
```

**方法3: Dockerコンテナ内から**
```bash
docker compose exec laravel php artisan route:list
```

**期待される出力**:
```
  GET|HEAD   api/health .........................................................
  GET|HEAD   api/user ...........................................................
```

#### ステップ6-3: データベース接続のテスト

```bash
# データベース内のユーザー一覧を取得
docker compose exec laravel php artisan tinker
```

**Tinker内で実行**:
```php
// すべてのユーザーを取得
\App\Models\User::all();

// すべてのツイートを取得
\App\Models\Tweet::with('user')->get();

// 終了
exit
```

---

### ステップ7: 統合テスト

#### 何をするか？

フロントエンド（React）からバックエンド（Laravel API）にリクエストを送信し、正しく通信できることを確認します。

#### ステップ7-1: テスト用APIエンドポイントの追加

**`backend/routes/api.php`**:
```php
use App\Models\Tweet;

Route::get('/tweets', function () {
    return response()->json([
        'data' => Tweet::with('user')->latest('posted_at')->limit(10)->get()
    ]);
});
```

#### ステップ7-2: ブラウザのコンソールからAPIを呼び出す

1. ブラウザで `http://localhost/` を開く
2. 開発者ツール（F12）を開く
3. **Console** タブで以下を実行：

```javascript
// Fetch APIでツイート一覧を取得
fetch('/api/tweets')
  .then(response => response.json())
  .then(data => {
    console.log('✅ API Response:', data);
  })
  .catch(error => {
    console.error('❌ API Error:', error);
  });
```

**期待される出力**:
```javascript
✅ API Response: {
  data: [
    {
      id: "uuid-here",
      body: "This is a tweet",
      user: {
        id: 1,
        name: "Test User",
        username: "testuser"
      },
      likes_count: 0,
      created_at: "2025-11-16T09:00:00.000000Z",
      updated_at: "2025-11-16T09:00:00.000000Z"
    },
    // ... more tweets
  ]
}
```

#### ステップ7-3: Reactから実際にAPIを呼び出す

**テスト用コンポーネントの作成**:

`frontend/src/App.tsx`を一時的に編集：

```tsx
import { Button } from './components/common/Button';
import { useState } from 'react';
import { tweetService } from './services/tweetService';
import type { Tweet } from './types/tweet';

function App() {
  const [tweets, setTweets] = useState<Tweet[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleFetchTweets = async () => {
    setLoading(true);
    setError(null);
    try {
      const data = await tweetService.getTweets();
      setTweets(data);
      console.log('✅ Tweets fetched:', data);
    } catch (err) {
      console.error('❌ Error fetching tweets:', err);
      setError('Failed to fetch tweets');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-gray-50 flex items-center justify-center p-8">
      <div className="max-w-2xl w-full">
        <div className="text-center mb-8">
          <h1 className="text-4xl font-bold text-gray-900 mb-4">Twitter Clone</h1>
          <p className="text-gray-600 mb-6">
            React + Vite + TypeScript + Tailwind CSS
          </p>
          <Button
            variant="primary"
            size="lg"
            onClick={handleFetchTweets}
            isLoading={loading}
          >
            Fetch Tweets from API
          </Button>
        </div>

        {error && (
          <div className="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
            {error}
          </div>
        )}

        {tweets.length > 0 && (
          <div className="bg-white rounded-lg shadow-md p-6">
            <h2 className="text-2xl font-bold mb-4">Tweets ({tweets.length})</h2>
            <div className="space-y-4">
              {tweets.map((tweet) => (
                <div key={tweet.id} className="border-b pb-4">
                  <div className="flex items-center mb-2">
                    <span className="font-bold">{tweet.user.name}</span>
                    <span className="text-gray-500 ml-2">@{tweet.user.username}</span>
                  </div>
                  <p className="text-gray-800">{tweet.body}</p>
                  <div className="text-gray-500 text-sm mt-2">
                    {new Date(tweet.created_at).toLocaleString()}
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}
      </div>
    </div>
  );
}

export default App;
```

#### ステップ7-4: 統合テストの実行

1. ブラウザで `http://localhost/` にアクセス
2. "Fetch Tweets from API" ボタンをクリック
3. ✅ ツイート一覧が表示される
4. ✅ コンソールにエラーがない
5. ✅ ネットワークタブで `/api/tweets` のリクエストが `200 OK` で返ってくる

**成功の証拠**:
- ツイートのリストが表示される
- ユーザー名、本文、日時が正しく表示される
- エラーメッセージが表示されない

---

## 4. 動作確認

### 4.1. チェックリスト

すべての項目にチェックが入ることを確認してください：

#### インフラ層
- [ ] すべてのDockerコンテナが起動している（`docker compose ps`）
- [ ] PostgreSQLが正常に稼働している
- [ ] Nginxが port 80 でリクエストを受け付けている

#### バックエンド（Laravel）
- [ ] Composerパッケージがインストールされている
- [ ] データベースマイグレーションが成功している
- [ ] `/api/health` エンドポイントが正常に応答する
- [ ] `/api/tweets` エンドポイントがJSONを返す

#### フロントエンド（React）
- [ ] `http://localhost/` でReactアプリが表示される
- [ ] Tailwind CSSのスタイルが適用されている
- [ ] HMR（Hot Module Replacement）が動作する
- [ ] ブラウザコンソールにエラーがない

#### 統合
- [ ] ReactからLaravel APIを呼び出せる
- [ ] CORS エラーが発生しない
- [ ] データが正しく表示される

### 4.2. パフォーマンスチェック

```bash
# 各コンテナのリソース使用状況を確認
docker stats

# コンテナの詳細情報
docker compose top
```

---

## 5. トラブルシューティング

### 問題1: ポート80がすでに使用されている

**症状**:
```
Error starting userland proxy: listen tcp4 0.0.0.0:80: bind: address already in use
```

**原因**: 他のプロセス（Apache、別のNginxなど）がポート80を使用している

**解決策1**: 使用中のプロセスを停止
```bash
# macOS/Linux
sudo lsof -i :80
sudo kill -9 <PID>

# Windows
netstat -ano | findstr :80
taskkill /PID <PID> /F
```

**解決策2**: docker-compose.ymlのポート番号を変更
```yaml
nginx:
  ports:
    - "8080:80"  # 80 → 8080 に変更
```

その後、`http://localhost:8080/` でアクセス

### 問題2: Reactコンテナが起動しない

**症状**:
```
docker compose logs react
...
npm ERR! code ENOENT
npm ERR! syscall open
npm ERR! path /app/package.json
```

**原因**: `frontend/` ディレクトリが正しくマウントされていない

**解決策**:
```bash
# コンテナを停止
docker compose down

# ボリュームを削除
docker volume ls
docker volume rm twitter-app_node_modules

# 再ビルド＆起動
docker compose up --build -d
```

### 問題3: Laravel - データベース接続エラー

**症状**:
```
SQLSTATE[08006] [7] could not connect to server: Connection refused
```

**原因**: データベースコンテナが完全に起動する前にLaravelが接続しようとしている

**解決策**:
```bash
# データベースの状態確認
docker compose logs db

# データベースが準備完了するまで待つ
docker compose exec db pg_isready -U laravel_user -d twitter_clone

# Laravelコンテナを再起動
docker compose restart laravel
```

### 問題4: Permission denied (Laravelストレージ)

**症状**:
```
The stream or file "/var/www/html/storage/logs/laravel.log" could not be opened: failed to open stream: Permission denied
```

**解決策**:
```bash
# 権限を修正
docker compose exec laravel chmod -R 775 storage bootstrap/cache
docker compose exec laravel chown -R www-data:www-data storage bootstrap/cache
```

### 問題5: CORS エラー

**症状**:
```
Access to fetch at 'http://localhost/api/tweets' from origin 'http://localhost:5173'
has been blocked by CORS policy
```

**原因**: Nginx経由でアクセスしていない

**解決策**:
- ✅ 正しい: `http://localhost/` （Nginx経由）
- ❌ 間違い: `http://localhost:5173/` （React直接）

Nginx経由でアクセスすることで、すべて同一オリジンになりCORS問題を回避

### 問題6: HMRが動作しない

**症状**: ファイルを変更してもブラウザに反映されない

**解決策**:
```bash
# Reactコンテナのログを確認
docker compose logs -f react

# vite.config.tsを確認
# server.watch.usePolling: true になっているか確認
```

### 問題7: ビルドが非常に遅い

**原因**: 初回ビルド時は依存パッケージのダウンロードに時間がかかる

**解決策**:
```bash
# キャッシュを活用（2回目以降は高速）
docker compose build

# 並列ビルドを有効化（Docker Desktopの設定）
# Settings > Resources > Advanced > CPUs を増やす
```

---

## 6. 次のステップ

Docker Compose統合が完了したので、次のステップに進めます：

### 推奨: タスク6 - 認証機能の実装

**内容**:
- Laravel Sanctum のセットアップ
- ユーザー登録・ログインAPIの実装（TDDで）
- React認証コンテキストの作成
- ログイン・登録フォームの実装

**学べること**:
- SPA認証の仕組み
- Cookie ベース認証のセキュリティ
- 保護されたルートの実装

### その他の候補

#### タスク7: ツイート投稿機能の実装（TDDで）
- ツイート投稿APIの実装（Red → Green → Refactor）
- フロントエンドのツイートフォーム作成
- リアルタイム更新

#### タスク8: いいね機能の実装
- いいねAPIの実装
- 楽観的UI更新
- アニメーション

---

## 📚 参考リソース

### Docker
- [Docker 公式ドキュメント](https://docs.docker.com/)
- [Docker Compose 公式ドキュメント](https://docs.docker.com/compose/)

### Nginx
- [Nginx as a Reverse Proxy](https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/)

### トラブルシューティング
- [Docker Desktop Troubleshooting](https://docs.docker.com/desktop/troubleshoot/overview/)

---

## ❓ よくある質問（FAQ）

### Q1: Docker Composeとdocker-composeの違いは？

**A**:
- **docker-compose**: 旧バージョン（v1）のコマンド
- **docker compose**: 新バージョン（v2）のコマンド（推奨）

Docker Desktop をインストールすると、v2が使えます。

### Q2: コンテナを停止するには？

**A**:
```bash
# すべてのコンテナを停止
docker compose down

# コンテナを停止（データは保持）
docker compose stop

# 特定のコンテナのみ停止
docker compose stop react
```

### Q3: データベースのデータを完全に削除するには？

**A**:
```bash
# コンテナとボリュームを削除
docker compose down -v

# 再起動時に新しいデータベースが作成される
docker compose up -d
```

**注意**: マイグレーションを再実行する必要があります。

### Q4: ログをファイルに保存するには？

**A**:
```bash
# すべてのログをファイルに保存
docker compose logs > logs.txt

# 特定のサービスのみ
docker compose logs react > react-logs.txt
```

### Q5: 本番環境でも同じdocker-compose.ymlを使える？

**A**: いいえ、本番環境用に別のファイルを作成すべきです。

**開発環境**: `docker-compose.yml`
**本番環境**: `docker-compose.prod.yml`

本番環境では以下を変更：
- デバッグモードをオフ
- ボリュームマウントを削除
- 環境変数をセキュアに管理
- リソース制限を設定

### Q6: 他の人と環境を共有するには？

**A**:
1. Gitリポジトリにコミット＆プッシュ
2. 相手が `git clone` でプロジェクトを取得
3. `docker compose up --build -d` で起動

すべての設定がコード化されているので、誰でも同じ環境を再現できます。

---

## ✅ タスク完了チェックリスト

以下がすべて完了していることを確認してください：

- [ ] Docker と Docker Compose がインストールされている
- [ ] `docker compose build` が成功する
- [ ] すべてのコンテナが起動している（`docker compose ps`）
- [ ] `http://localhost/` でReactアプリが表示される
- [ ] `/api/health` エンドポイントが正常に応答する
- [ ] データベースマイグレーションが成功している
- [ ] ReactからLaravel APIを呼び出せる
- [ ] HMR（Hot Module Replacement）が動作する
- [ ] ブラウザコンソールにエラーがない
- [ ] すべてのログに致命的なエラーがない

---

**最終更新日**: 2025-11-16
**タスクステータス**: 📝 作成済み（実施待ち）
**次のタスク**: タスク6 - 認証機能の実装（Laravel Sanctum + React）
